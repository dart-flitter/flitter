library flitter.redux.actions;

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/gitter/src/models/token.dart';
import 'package:flutter/material.dart';

abstract class FlitterAction {
  FlitterAction();
  String toString() => '$runtimeType';
}

class AuthGitterAction extends FlitterAction {
  final GitterToken token;
  AuthGitterAction(this.token);
}

class InitAppAction extends FlitterAction {
  InitAppAction();
}

class FetchRoomsAction extends FlitterAction {
  final Iterable<Room> rooms;
  FetchRoomsAction(this.rooms);
}

class FetchGroupsAction extends FlitterAction {
  final Iterable<Group> groups;
  FetchGroupsAction(this.groups);
}

class LogoutAction extends FlitterAction {
  LogoutAction();
}

class FetchUser extends FlitterAction {
  final User user;
  FetchUser(this.user);
}

class SelectRoomAction extends FlitterAction {
  final Room room;
  SelectRoomAction(this.room);
}

class FetchMessagesForRoomAction extends FlitterAction {
  final Iterable<Message> messages;
  final String roomId;
  FetchMessagesForRoomAction(this.messages, this.roomId);
}

class OnMessagesForRoom extends FlitterAction {
  final Iterable<Message> messages;
  final String roomId;
  OnMessagesForRoom(this.messages, this.roomId);
}

class OnMessage extends FlitterAction {
  final Message message;
  final String roomId;
  OnMessage(this.message, this.roomId);
}

class JoinRoomAction extends FlitterAction {
  final Room room;
  JoinRoomAction(this.room);
}

class LeaveRoomAction extends FlitterAction {
  final Room room;
  LeaveRoomAction(this.room);
}

class OnSendMessage extends FlitterAction {
  final Message message;
  final String roomId;
  OnSendMessage(this.message, this.roomId);
}

class FetchRoomsOfGroup extends FlitterAction {
  final Iterable<Room> rooms;
  FetchRoomsOfGroup(this.rooms);
}

class SelectGroupAction extends FlitterAction {
  final Group group;
  SelectGroupAction(this.group);
}

class ShowSearchBarAction extends FlitterAction {
  ShowSearchBarAction();
}

class StartSearchAction extends FlitterAction {
  StartSearchAction();
}

class EndSearchAction extends FlitterAction {
  EndSearchAction();
}

class FetchSearchAction<T> extends FlitterAction {
  final Iterable<T> result;
  FetchSearchAction(this.result);
}

class ChangeThemeAction extends FlitterAction {
  final Brightness brightness;
  final MaterialColor primarySwatch;
  final MaterialColor secondarySwatch;

  ChangeThemeAction(this.brightness, this.primarySwatch, this.secondarySwatch);
}
