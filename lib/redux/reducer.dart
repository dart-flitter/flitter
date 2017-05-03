library flitter.redux.reducer;

import 'package:flutter/material.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:redux/redux.dart' as redux;

class LoggingMiddleware
    implements redux.Middleware<FlitterState, FlitterAction> {
  call(redux.Store<FlitterState, FlitterAction> store, FlitterAction action,
      next) {
    debugPrint('${new DateTime.now()}: $action');
    next(action);
  }
}

class SearchState {
  final result;
  final bool requesting;

  SearchState({this.result, this.requesting});
}

class CurrentRoomState {
  final Room room;
  final List<Message> messages;

  CurrentRoomState({this.room, this.messages});

  CurrentRoomState apply({Room room, List<Message> messages}) {
    return new CurrentRoomState(
        room: room ?? this.room, messages: messages ?? this.messages);
  }
}

class FlitterState {
  final GitterApi api;
  final List<Room> rooms;
  final List<Group> groups;
  final User user;
  final Map<String, List<Message>> messages;
  final bool init;
  final CurrentRoomState selectedRoom;
  final SearchState search;

  FlitterState(
      {this.api,
      this.rooms,
      this.groups,
      this.user,
      this.messages,
      this.init,
      this.search,
      this.selectedRoom});

  FlitterState.initial()
      : api = null,
        rooms = null,
        groups = null,
        user = null,
        messages = const <String, List<Message>>{},
        init = false,
        selectedRoom = null,
        search = null;

  FlitterState apply(
      {GitterApi api,
      List<Room> rooms,
      List<Group> groups,
      User user,
      Map<String, List<Message>> messages,
      bool init,
      CurrentRoomState selectedRoom,
      SearchState search}) {
    return new FlitterState(
        api: api ?? this.api,
        rooms: rooms ?? this.rooms,
        groups: groups ?? this.groups,
        user: user ?? this.user,
        messages: messages ?? this.messages,
        init: init ?? this.init,
        selectedRoom: selectedRoom ?? this.selectedRoom,
        search: search ?? this.search);
  }
}

class FlitterReducer extends redux.Reducer<FlitterState, FlitterAction> {
  @override
  FlitterState reduce(FlitterState state, FlitterAction action) {
    if (action is InitGitterAction) {
      return state.apply(api: action.api, init: true);
    } else if (action is FetchRoomsAction) {
      return state.apply(rooms: action.romms);
    } else if (action is FetchGroupsAction) {
      return state.apply(groups: action.groups);
    } else if (action is LogoutAction) {
      return state.apply(
          rooms: [], api: null, user: null, groups: [], messages: {});
    } else if (action is LoginAction) {
      return state.apply(user: action.user, api: action.api);
    } else if (action is SelectRoomAction) {
      CurrentRoomState current = new CurrentRoomState(
          room: action.room, messages: state.messages[action.room.id]);
      return state.apply(selectedRoom: current);
    } else if (action is FetchMessagesForRoomAction) {
      Map<String, List<Message>> messages = state.messages;
      messages[action.roomId] = action.messages;
      return state.apply(messages: messages);
    } else if (action is OnMessagesForRoom) {
      List<Message> messages = new List.from(action.messages);
      Map<String, List<Message>> messagesByRooms = new Map.from(state.messages);
      messages.addAll(state.messages[action.roomId] ?? []);
      messagesByRooms[action.roomId] = messages;
      CurrentRoomState currentRoom =
          state.selectedRoom?.apply(messages: messagesByRooms[action.roomId]);
      return state.apply(messages:  messagesByRooms, selectedRoom: currentRoom);
    } else if (action is JoinRoomAction) {
      List<Room> rooms = new List.from(state.rooms);
      rooms.add(action.room);
      return state.apply(rooms: rooms);
    } else if (action is LeaveRoomAction) {
      List<Room> rooms = new List.from(state.rooms);
      rooms.removeWhere((Room room) => room.id == action.room.id);
      return state.apply(rooms: rooms);
    } else if (action is OnSendMessage) {
      Map<String, List<Message>> messages = new Map.from(state.messages);
      messages[action.roomId] ??= [];
      messages[action.roomId].add(action.message);
      CurrentRoomState currentRoom =
          state.selectedRoom?.apply(messages: messages[action.roomId]);
      return state.apply(messages: messages, selectedRoom: currentRoom);
    }

    return state;
  }
}
