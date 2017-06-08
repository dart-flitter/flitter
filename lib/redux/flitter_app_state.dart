import 'package:gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:gitter/src/faye.dart';

class ThemeState {
  final Brightness brightness;
  final MaterialColor primarySwatch;
  final MaterialColor secondarySwatch;
  final ThemeData _theme;

  ThemeData get theme => _theme;

  ThemeState({this.brightness, this.primarySwatch, this.secondarySwatch})
      : _theme = new ThemeData(
            brightness: brightness,
            primarySwatch: primarySwatch,
            accentColor: secondarySwatch[500]);

  factory ThemeState.initial() => new ThemeState(
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      secondarySwatch: Colors.pink);

  ThemeState apply(
      {Brightness brightness,
      MaterialColor primarySwatch,
      MaterialColor secondarySwatch}) {
    return new ThemeState(
        brightness: brightness ?? this.brightness,
        primarySwatch: primarySwatch ?? this.primarySwatch,
        secondarySwatch: secondarySwatch ?? this.secondarySwatch);
  }
}

class SearchState {
  final Iterable result;
  final bool requesting;
  final bool searching;

  SearchState({this.result, this.requesting, this.searching});

  SearchState.initial()
      : result = [],
        requesting = false,
        searching = false;

  SearchState apply({Iterable result, bool requesting, bool searching}) {
    return new SearchState(
        result: result ?? this.result,
        requesting: requesting ?? this.requesting,
        searching: searching ?? this.searching);
  }
}

class CurrentRoomState {
  final Room room;
  final Iterable<Message> messages;

  CurrentRoomState({this.room, this.messages});

  CurrentRoomState apply({Room room, Iterable<Message> messages}) {
    return new CurrentRoomState(
        room: room ?? this.room, messages: messages ?? this.messages);
  }
}

class CurrentGroupState {
  final Group group;
  final Iterable<Room> rooms;

  CurrentGroupState({this.group, this.rooms});

  CurrentGroupState apply({Group group, Iterable<Room> rooms}) {
    return new CurrentGroupState(
        group: group ?? this.group, rooms: rooms ?? this.rooms);
  }
}

class FlitterAppState {
  final Iterable<Room> rooms;
  final Iterable<Group> groups;
  final User user;
  final CurrentRoomState selectedRoom;
  final CurrentGroupState selectedGroup;
  final SearchState search;

  FlitterAppState(
      {this.rooms,
      this.groups,
      this.user,
      this.search,
      this.selectedRoom,
      this.selectedGroup});

  FlitterAppState.initial()
      : rooms = null,
        groups = null,
        user = null,
        selectedRoom = null,
        search = new SearchState.initial(),
        selectedGroup = null;

  FlitterAppState apply(
      {Iterable<Room> rooms,
      Iterable<Group> groups,
      User user,
      bool init,
      CurrentRoomState selectedRoom,
      SearchState search,
      CurrentGroupState selectedGroup,
      GitterApi api,
      GitterToken token}) {
    return new FlitterAppState(
        rooms: rooms ?? this.rooms,
        groups: groups ?? this.groups,
        user: user ?? this.user,
        selectedRoom: selectedRoom ?? this.selectedRoom,
        search: search ?? this.search,
        selectedGroup: selectedGroup ?? this.selectedGroup);
  }
}

class GitterState {
  final GitterApi api;
  final GitterToken token;
  final GitterFayeSubscriber subscriber;

  GitterState({this.api, this.token, this.subscriber});

  GitterState apply(
      {GitterApi api, GitterToken token, GitterFayeSubscriber subscriber}) {
    return new GitterState(
        api: api ?? this.api,
        token: token ?? this.token,
        subscriber: subscriber ?? this.subscriber);
  }

  GitterState.initial()
      : api = null,
        token = null,
        subscriber = null;
}
