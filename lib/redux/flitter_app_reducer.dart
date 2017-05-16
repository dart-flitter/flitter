import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart' as redux;

T orElseNull<T>() => null;

class ThemeReducer extends redux.Reducer<ThemeState, FlitterAction> {
  final _mapper = const <Type, Function>{ChangeThemeAction: _changeThemeAction};

  @override
  ThemeState reduce(ThemeState state, FlitterAction action) {
    return state;
  }
}

ThemeState _changeThemeAction(ThemeState state, ChangeThemeAction action) {
  return state.apply(
      accentColor: action.accentColor,
      primarySwatch: action.primarySwatch,
      brightness: action.brightness);
}

class FlitterLoggingMiddleware
    implements redux.Middleware<FlitterAppState, FlitterAction> {
  call(redux.Store<FlitterAppState, FlitterAction> store, FlitterAction action,
      next) {
    debugPrint('${new DateTime.now()}: $action');
    next(action);
  }
}

class FlitterAppReducer extends redux.Reducer<FlitterAppState, FlitterAction> {
  final _mapper = const <Type, Function>{
    FetchRoomsAction: _fetchRooms,
    FetchGroupsAction: _fetchGroups,
    FetchUser: _fetchUser,
    SelectRoomAction: _selectRoom,
    OnMessagesForRoom: _onMessages,
    OnSendMessage: _onSendMessage,
    FetchMessagesForRoomAction: _fetchMessages,
    JoinRoomAction: _joinRoom,
    LeaveRoomAction: _leaveRoom,
    SelectGroupAction: _selectGroup,
    FetchRoomsOfGroup: _fetchRoomsOfGroup,
    ShowSearchBarAction: _showSearchBar,
    StartSearchAction: _startSearch,
    EndSearchAction: _endSearch,
    FetchSearchAction: _fetchSearch,
    LogoutAction: _logout,
    AuthGitterAction: _initGitter,
    OnMessage: _onMessage
  };

  @override
  FlitterAppState reduce(FlitterAppState state, FlitterAction action) {
    Function reducer = _mapper[action.runtimeType];
    return reducer != null ? reducer(state, action) : state;
  }
}

FlitterAppState _showSearchBar(
    FlitterAppState state, ShowSearchBarAction action) {
  return state.apply(search: state.search.apply(searching: true, result: []));
}

FlitterAppState _startSearch(FlitterAppState state, StartSearchAction action) {
  return state.apply(
      search:
          state.search.apply(searching: true, requesting: true, result: []));
}

FlitterAppState _fetchSearch(FlitterAppState state, FetchSearchAction action) {
  return state.apply(
      search: state.search
          .apply(searching: true, requesting: false, result: action.result));
}

FlitterAppState _endSearch(FlitterAppState state, EndSearchAction action) {
  return state.apply(
      search:
          state.search.apply(searching: false, requesting: false, result: []));
}

FlitterAppState _fetchRooms(FlitterAppState state, FetchRoomsAction action) {
  return state.apply(rooms: action.rooms);
}

FlitterAppState _fetchGroups(FlitterAppState state, FetchGroupsAction action) {
  return state.apply(groups: action.groups);
}

FlitterAppState _fetchUser(FlitterAppState state, FetchUser action) {
  return state.apply(user: action.user);
}

FlitterAppState _selectRoom(FlitterAppState state, SelectRoomAction action) {
  CurrentRoomState current = new CurrentRoomState(
      room: action.room, messages: state.messages[action.room.id]);
  return state.apply(selectedRoom: current);
}

FlitterAppState _fetchMessages(
    FlitterAppState state, FetchMessagesForRoomAction action) {
  Map<String, Iterable<Message>> messages = state.messages;
  messages[action.roomId] = action.messages;
  return state.apply(messages: messages);
}

FlitterAppState _onMessages(FlitterAppState state, OnMessagesForRoom action) {
  final messages = new List<Message>.from(action.messages);
  final messagesByRooms = new Map.from(state.messages);
  messages.addAll(state.messages[action.roomId] ?? []);
  messagesByRooms[action.roomId] = messages;
  final currentRoom =
      state.selectedRoom?.apply(messages: messagesByRooms[action.roomId]);
  return state.apply(messages: messagesByRooms, selectedRoom: currentRoom);
}

FlitterAppState _joinRoom(FlitterAppState state, JoinRoomAction action) {
  final rooms = new List<Room>.from(state.rooms);
  rooms.add(action.room);
  return state.apply(rooms: rooms);
}

FlitterAppState _leaveRoom(FlitterAppState state, LeaveRoomAction action) {
  final rooms = new List<Room>.from(state.rooms);
  rooms.removeWhere((Room room) => room.id == action.room.id);
  return state.apply(rooms: rooms);
}

FlitterAppState _onSendMessage(FlitterAppState state, OnSendMessage action) {
  Map<String, Iterable<Message>> messages =
      _addOrUpdateMessage(state, action.message, action.roomId);
  CurrentRoomState currentRoom =
      state.selectedRoom?.apply(messages: messages[action.roomId]);
  return state.apply(messages: messages, selectedRoom: currentRoom);
}

FlitterAppState _selectGroup(FlitterAppState state, SelectGroupAction action) {
  CurrentGroupState current = new CurrentGroupState(group: action.group);
  return state.apply(selectedGroup: current);
}

FlitterAppState _fetchRoomsOfGroup(
    FlitterAppState state, FetchRoomsOfGroup action) {
  CurrentGroupState current = new CurrentGroupState(
      group: state.selectedGroup.group, rooms: action.rooms);
  return state.apply(selectedGroup: current);
}

FlitterAppState _logout(FlitterAppState state, LogoutAction action) {
  return new FlitterAppState.initial();
}

FlitterAppState _initGitter(FlitterAppState state, AuthGitterAction action) {
  GitterApi api;
  if (action.token != null) {
    api = new GitterApi(action.token);
  }
  return state.apply(api: api, token: action.token);
}

FlitterAppState _onMessage(FlitterAppState state, OnMessage action) {
  Map<String, Iterable<Message>> messages =
      _addOrUpdateMessage(state, action.message, action.roomId);

  final currentRoom =
      state.selectedRoom?.apply(messages: messages[action.roomId]);
  if (currentRoom?.room?.id == action.roomId) {
    return state.apply(messages: messages, selectedRoom: currentRoom);
  }
  return state.apply(messages: messages);
}

Map<String, Iterable<Message>> _addOrUpdateMessage(
    FlitterAppState state, Message message, String roomId) {
  Map<String, Iterable<Message>> messages = new Map.from(state.messages);
  messages[roomId] ??= [];

  final exist = messages[roomId]
      .firstWhere((msg) => msg.id == message.id, orElse: orElseNull);

  if (exist != null) {
    final list = messages[roomId].toList();
    final idx = list.indexOf(exist);
    list[idx] = message;
    messages[roomId] = list;
  } else {
    messages[roomId] = messages[roomId].toList()..add(message);
  }
  return messages;
}
