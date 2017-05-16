import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/gitter/gitter.dart';

Future<Iterable<Room>> fetchRooms() async {
  final rooms = await gitterApi.user.me.rooms();
  flitterStore.dispatch(new FetchRoomsAction(rooms));
  return rooms;
}

Future<User> fetchUser() async {
  final user = await gitterApi.user.me.get();
  flitterStore.dispatch(new FetchUser(user));
  return user;
}

Future<Iterable<Group>> fetchGroups() async {
  final groups = await gitterApi.group.get();
  flitterStore.dispatch(new FetchGroupsAction(groups));
  return groups;
}

Future<Iterable<Room>> fetchRoomsOfGroup() async {
  final groupId = flitterStore.state.selectedGroup.group.id;
  final rooms = await gitterApi.group.suggestedRoomsOf(groupId);
  flitterStore.dispatch(new FetchRoomsOfGroup(rooms));
  return rooms;
}

Future<Iterable<Message>> fetchMessagesOfRoom(
    String roomId, String beforeId) async {
  final messages =
      await gitterApi.room.messagesFromRoomId(roomId, beforeId: beforeId);
  flitterStore.dispatch(new OnMessagesForRoom(messages, roomId));
  return messages;
}

Future<bool> leaveRoom(Room room) async {
  final success =
      await gitterApi.room.removeUserFrom(room.id, flitterStore.state.user.id);
  if (success == true) {
    flitterStore.dispatch(new LeaveRoomAction(room));
  }
  return success;
}

Future<Room> joinRoom(Room room) async {
  final joinedRoom =
      await gitterApi.user.userJoinRoom(flitterStore.state.user.id, room.id);
  flitterStore.dispatch(new JoinRoomAction(room));
  return joinedRoom;
}

Future<Message> sendMessage(String value, Room room) async {
  final message =
      await gitterApi.room.sendMessageToRoomId(room.id, value);
  flitterStore.dispatch(new OnSendMessage(message, room.id));
  return message;
}

Future<Iterable> search(String query) async {
  flitterStore.dispatch(new StartSearchAction());
  final result = [];
  result.addAll(await gitterApi.user.search(query, limit: 5));
  result.addAll(await gitterApi.room.search(query, limit: 10));
  flitterStore.dispatch(new FetchSearchAction(result));
  return result;
}

initBasicData() async {
  if (flitterStore.state.user == null) {
    await fetchUser();
  }
  if (flitterStore.state.groups == null) {
    await fetchGroups();
  }
}
