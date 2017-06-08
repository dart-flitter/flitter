import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:gitter/gitter.dart';
import 'package:gitter/src/faye.dart';
import 'package:gitter/src/models/faye_message.dart';

Future<Iterable<Room>> fetchRooms() async {
  final rooms = await gitterApi.user.me.rooms();
  flitterStore.dispatch(new FetchRoomsAction(rooms));
  subscribeToUnreadMessages(rooms);
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
  subscribeToUnreadMessages(rooms);
  return rooms;
}

Future<Iterable<Message>> fetchMessagesOfRoom(
    String roomId, String beforeId) async {
  final messages =
      await gitterApi.room.messagesFromRoomId(roomId, beforeId: beforeId);
  flitterStore.dispatch(new OnMessagesForCurrentRoom(messages));
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
  final message = await gitterApi.room.sendMessageToRoomId(room.id, value);
  flitterStore.dispatch(new OnSendMessage(message));
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

initStores(GitterToken token) async {
  flitterStore = new FlitterStore();
  gitterStore
      .dispatch(new AuthGitterAction(token, await initWebSocket(token.access)));
  fetchRooms();
  fetchGroups();
}

List<String> _mapperUnreads;

Future<GitterFayeSubscriber> initWebSocket(String token) async {
  gitterSubscriber?.close();
  _mapperUnreads = [];
  GitterFayeSubscriber subscriber = new GitterFayeSubscriber(token);
  await subscriber.connect();
  flitterStore.dispatch(new FetchUser(subscriber.user));
  return subscriber;
}

subscribeToUnreadMessages(List<Room> rooms) {
  final newRooms =
      rooms.map((r) => r.id).where((r) => !_mapperUnreads.contains(r)).toList();
  _mapperUnreads.addAll(newRooms);
  for (String roomId in newRooms) {
    gitterSubscriber.subscribeToUserRoomUnreadItems(
        roomId, gitterSubscriber.user.id, (List<GitterFayeMessage> messages) {
      for (GitterFayeMessage msg in messages) {
        if (msg.data != null &&
            msg.data["notification"] == GitterFayeNotifications.unreadItems) {
          flitterStore.dispatch(new UnreadMessagesForRoom(
              roomId: roomId, addMessage: msg.data["items"]["chat"].length));
        } else if (msg.data != null &&
            msg.data["notification"] ==
                GitterFayeNotifications.unreadItemsRemoved) {
          flitterStore.dispatch(new UnreadMessagesForRoom(
              roomId: roomId, removeMessage: msg.data["items"]["chat"].length));
        }
      }
    });
  }
}
