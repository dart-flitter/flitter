import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart' as redux;

T orElseNull<T>() => null;

class ThemeReducer extends redux.Reducer<ThemeState, FlitterAction> {
  final _mapper = const <Type, Function>{ChangeThemeAction: _changeThemeAction};

  @override
  ThemeState reduce(ThemeState state, FlitterAction action) {
    Function reducer = _mapper[action.runtimeType];
    return reducer != null ? reducer(state, action) : state;
  }
}

ThemeState _changeThemeAction(ThemeState state, ChangeThemeAction action) {
  return state.apply(
      primaryColor: action.primaryColor,
      brightness: action.brightness,
      accentColor: action.accentColor);
}

class FlitterLoggingMiddleware
    implements redux.Middleware<FlitterAppState, FlitterAction> {
  const FlitterLoggingMiddleware();

  call(redux.Store<FlitterAppState, FlitterAction> store, FlitterAction action,
      next) {
    debugPrint('${new DateTime.now()}: $action');
    next(action);
  }
}

class GitterLoggingMiddleware
    implements redux.Middleware<GitterState, FlitterAction> {
  const GitterLoggingMiddleware();

  call(redux.Store<GitterState, FlitterAction> store, FlitterAction action,
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
    OnMessagesForCurrentRoom: _onMessages,
    OnSendMessage: _onSendMessage,
    FetchMessagesForCurrentRoomAction: _fetchMessages,
    JoinRoomAction: _joinRoom,
    LeaveRoomAction: _leaveRoom,
    SelectGroupAction: _selectGroup,
    FetchRoomsOfGroup: _fetchRoomsOfGroup,
    ShowSearchBarAction: _showSearchBar,
    StartSearchAction: _startSearch,
    EndSearchAction: _endSearch,
    FetchSearchAction: _fetchSearch,
    OnMessageForCurrentRoom: _onMessageForCurrentRoom,
    UnreadMessagesForRoom: _unreadMessageForRoom
  };

  @override
  FlitterAppState reduce(FlitterAppState state, FlitterAction action) {
    Function reducer = _mapper[action.runtimeType];
    return reducer != null ? reducer(state, action) : state;
  }
}

FlitterAppState _unreadMessageForRoom(
    FlitterAppState state, UnreadMessagesForRoom action) {
  if (action.roomId != null) {
    Room room = state.rooms.firstWhere((Room room) => room.id == action.roomId,
        orElse: orElseNull);
    room.unreadItems += action.addMessage;
    room.unreadItems -= action.removeMessage;

    List<Room> rooms =
        state.rooms.where((Room room) => room.id != action.roomId).toList();
    rooms.add(room);

    return state.apply(rooms: _sortRooms(rooms));
  }
  return state;
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

List<Room> _sortRooms(List<Room> rooms) {
  final unreadRooms = rooms.where((Room r) => r.unreadItems > 0).toList();
  unreadRooms.sort((Room a, Room b) {
    return b.unreadItems - a.unreadItems;
  });

  final readedRooms = rooms.where((Room r) => r.unreadItems == 0).toList();
  readedRooms.sort((Room a, Room b) {
    if (a.lastAccessTime != null && b.lastAccessTime != null) {
      DateTime lA = parseLastAccessTime(a.lastAccessTime);
      DateTime lB = parseLastAccessTime(b.lastAccessTime);
      return lB.millisecondsSinceEpoch - lA.millisecondsSinceEpoch;
    }
    return 0;
  });

  final _rooms = [];
  _rooms.addAll(unreadRooms);
  _rooms.addAll(readedRooms);

  return _rooms;
}

FlitterAppState _fetchRooms(FlitterAppState state, FetchRoomsAction action) {
  return state.apply(rooms: _sortRooms(action.rooms));
}

FlitterAppState _fetchGroups(FlitterAppState state, FetchGroupsAction action) {
  return state.apply(groups: action.groups);
}

FlitterAppState _fetchUser(FlitterAppState state, FetchUser action) {
  return state.apply(user: action.user);
}

FlitterAppState _selectRoom(FlitterAppState state, SelectRoomAction action) {
  CurrentRoomState current =
      new CurrentRoomState(room: action.room, messages: null);
  return state.apply(selectedRoom: current);
}

FlitterAppState _fetchMessages(
    FlitterAppState state, FetchMessagesForCurrentRoomAction action) {
  final currentRoom = state.selectedRoom?.apply(messages: action.messages);
  return state.apply(selectedRoom: currentRoom);
}

FlitterAppState _onMessages(
    FlitterAppState state, OnMessagesForCurrentRoom action) {
  final messages = new List<Message>.from(action.messages);
  final messagesRooms =
      new List<Message>.from(state.selectedRoom.messages ?? []);
  messages.addAll(messagesRooms ?? []);
  final currentRoom = state.selectedRoom?.apply(messages: messages);
  return state.apply(selectedRoom: currentRoom);
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
  Iterable<Message> messages = _addOrUpdateMessage(state, action.message);
  CurrentRoomState currentRoom = state.selectedRoom?.apply(messages: messages);
  return state.apply(selectedRoom: currentRoom);
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

FlitterAppState _onMessageForCurrentRoom(
    FlitterAppState state, OnMessageForCurrentRoom action) {
  Iterable<Message> messages = _addOrUpdateMessage(state, action.message);

  final currentRoom = state.selectedRoom?.apply(messages: messages);
  return state.apply(selectedRoom: currentRoom);
}

Iterable<Message> _addOrUpdateMessage(FlitterAppState state, Message message) {
  List<Message> messages = new List.from(state.selectedRoom.messages ?? []);

  final exist =
      messages.firstWhere((msg) => msg.id == message.id, orElse: orElseNull);

  if (exist != null) {
    final idx = messages.indexOf(exist);
    messages[idx] = message;
  } else {
    messages.add(message);
  }
  return messages;
}

class GitterReducer extends redux.Reducer<GitterState, FlitterAction> {
  final _mapper = const <Type, Function>{
    AuthGitterAction: _initGitter,
    LogoutAction: _logout
  };

  @override
  GitterState reduce(GitterState state, FlitterAction action) {
    Function reducer = _mapper[action.runtimeType];
    return reducer != null ? reducer(state, action) : state;
  }
}

GitterState _initGitter(GitterState state, AuthGitterAction action) {
  GitterApi api;
  if (action.token != null) {
    api = new GitterApi(action.token);
  }
  return state.apply(
      api: api, token: action.token, subscriber: action.subscriber);
}

GitterState _logout(GitterState state, LogoutAction action) {
  state.subscriber?.close();
  flitterStore = null;
  return new GitterState.initial();
}
