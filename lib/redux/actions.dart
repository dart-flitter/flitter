library flitter.redux.actions;

import 'package:gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:gitter/src/faye.dart';

abstract class FlitterAction {
  FlitterAction();

  String toString() => '$runtimeType';
}

class AuthGitterAction extends FlitterAction {
  final GitterToken token;
  final GitterFayeSubscriber subscriber;

  AuthGitterAction(this.token, this.subscriber);
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

class FetchMessagesForCurrentRoomAction extends FlitterAction {
  final Iterable<Message> messages;

  FetchMessagesForCurrentRoomAction(this.messages);
}

class OnMessagesForCurrentRoom extends FlitterAction {
  final Iterable<Message> messages;

  OnMessagesForCurrentRoom(this.messages);
}

class OnMessageForCurrentRoom extends FlitterAction {
  final Message message;

  OnMessageForCurrentRoom(this.message);
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

  OnSendMessage(this.message);
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
  final MaterialColor primaryColor;
  final MaterialAccentColor accentColor;

  ChangeThemeAction({this.brightness, this.primaryColor, this.accentColor});
}

class UnreadMessagesForRoom extends FlitterAction {
  final String roomId;
  final num addMessage;
  final num removeMessage;

  UnreadMessagesForRoom(
      {this.roomId, this.addMessage: 0, this.removeMessage: 0});
}
