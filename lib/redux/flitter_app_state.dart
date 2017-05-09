import 'package:flitter/services/gitter/gitter.dart';

class SearchState {
  final List result;
  final bool requesting;
  final bool searching;

  SearchState({this.result, this.requesting, this.searching});

  SearchState.initial()
      : result = [],
        requesting = false,
        searching = false;

  SearchState apply({List result, bool requesting, bool searching}) {
    return new SearchState(
        result: result ?? this.result,
        requesting: requesting ?? this.requesting,
        searching: searching ?? this.searching);
  }
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
  final GitterApi api;
  final GitterToken token;

  FlitterAppState(
      {this.api,
      this.token,
      this.rooms,
      this.groups,
      this.user,
      this.messages,
      this.search,
      this.selectedRoom,
      this.selectedGroup});

  FlitterAppState.initial()
      : api = null,
        token = null,
        rooms = null,
        groups = null,
        user = null,
        messages = const <String, List<Message>>{},
        selectedRoom = null,
        search = new SearchState.initial(),
        selectedGroup = null;

  FlitterAppState apply(
      {List<Room> rooms,
      List<Group> groups,
      User user,
      Map<String, List<Message>> messages,
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
        messages: messages ?? this.messages,
        selectedRoom: selectedRoom ?? this.selectedRoom,
        search: search ?? this.search,
        selectedGroup: selectedGroup ?? this.selectedGroup,
        api: api ?? this.api,
        token: token ?? this.token);
  }
}
