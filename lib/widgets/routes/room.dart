library flitter.routes.room;

import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/widgets/common/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:gitter/src/models/faye_message.dart';

enum RoomMenuAction { leave }

class RoomView extends StatefulWidget {
  static const path = "/room";

  RoomView();

  @override
  _RoomViewState createState() => new _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  Iterable<Message> get messages => flitterStore.state.selectedRoom.messages;

  Room get room => flitterStore.state.selectedRoom.room;

  var _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = flitterStore.onChange.listen((_) {
      setState(() {});
    });

    _fetchMessages();

    gitterSubscriber.subscribeToChatMessages(room.id, _onMessageHandler);
  }

  _onMessageHandler(List<GitterFayeMessage> msgs) {
    for (GitterFayeMessage msg in msgs) {
      if (msg.data != null && msg.data["operation"] == "create") {
        flitterStore.dispatch(new OnMessageForCurrentRoom(
            new Message.fromJson(msg.data["model"])));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    gitterSubscriber.unsubscribeToChatMessages(room.id);
  }

  @override
  Widget build(BuildContext context) {
    var body;

    if (messages != null) {
      final ChatRoom chatRoom =
          new ChatRoom(messages: messages.toList().reversed, room: room);
      chatRoom.onNeedDataStream.listen((_) => _fetchMessages());
      body = chatRoom;
    } else {
      body = new LoadingView();
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text(room.name), actions: [_buildMenu()]),
        body: body,
        floatingActionButton:
            _userHasJoined || messages == null ? null : _joinRoomButton());
  }

  _fetchMessages() {
    String id = messages?.isNotEmpty == true ? messages.first.id : null;
    fetchMessagesOfRoom(room.id, id);
  }

  Widget _buildMenu() => new PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuItem<RoomMenuAction>>[
            new PopupMenuItem<RoomMenuAction>(
                value: RoomMenuAction.leave,
                child: new Text('Leave room')) //todo: intl
          ],
      onSelected: (RoomMenuAction action) {
        switch (action) {
          case RoomMenuAction.leave:
            _onLeaveRoom();
            break;
        }
      });

  _onLeaveRoom() async {
    bool success = await leaveRoom(room);
    if (success == true) {
      Navigator.of(context).pop();
    } else {
      // Todo: show error
    }
  }

  Widget _joinRoomButton() {
    return new FloatingActionButton(
        child: new Icon(Icons.message), onPressed: _onTapJoinRoom);
  }

  void _onTapJoinRoom() {
    joinRoom(room);
  }

  bool get _userHasJoined =>
      flitterStore.state.rooms.any((Room r) => r.id == room.id);
}
