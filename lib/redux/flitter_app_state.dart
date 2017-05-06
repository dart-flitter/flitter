import 'package:flitter/services/gitter/gitter.dart';

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

class CurrentGroupState {
  final Group group;
  final List<Room> rooms;

  CurrentGroupState({this.group, this.rooms});

  CurrentGroupState apply({Group group, List<Room> rooms}) {
    return new CurrentGroupState(
        group: group ?? this.group, rooms: rooms ?? this.rooms);
  }
}

class FlitterAppState {
  final List<Room> rooms;
  final List<Group> groups;
  final User user;
  final Map<String, List<Message>> messages;
  final CurrentRoomState selectedRoom;
  final SearchState search;
  final CurrentGroupState selectedGroup;

  FlitterAppState(
      {this.rooms,
      this.groups,
      this.user,
      this.messages,
      this.search,
      this.selectedRoom,
      this.selectedGroup});

  FlitterAppState.initial()
      : rooms = null,
        groups = null,
        user = null,
        messages = const <String, List<Message>>{},
        selectedRoom = null,
        search = null,
        selectedGroup = null;

  FlitterAppState apply(
      {List<Room> rooms,
      List<Group> groups,
      User user,
      Map<String, List<Message>> messages,
      bool init,
      CurrentRoomState selectedRoom,
      SearchState search,
      CurrentGroupState selectedGroup}) {
    return new FlitterAppState(
        rooms: rooms ?? this.rooms,
        groups: groups ?? this.groups,
        user: user ?? this.user,
        messages: messages ?? this.messages,
        selectedRoom: selectedRoom ?? this.selectedRoom,
        search: search ?? this.search,
        selectedGroup: selectedGroup ?? this.selectedGroup);
  }
}
