library flitter.routes.room;

import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/chat_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';

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
  var _subscriptionMessages;

  @override
  void initState() {
    super.initState();
    _subscription = flitterStore.onChange.listen((_) {
      setState(() {});
    });

    if (messages == null) {
      _fetchMessages();
    }

    gitterApi.room
        .streamMessagesOfRoom(room.id)
        .then((Stream<Message> messages) {
      _subscriptionMessages = messages.listen((Message msg) {
        flitterStore.dispatch(new OnMessage(msg, room.id));
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
    _subscriptionMessages?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var body;

    if (messages != null) {
      final ChatRoomWidget chatRoom =
          new ChatRoomWidget(messages: messages.toList().reversed);
      chatRoom.onNeedDataStream.listen((_) => _fetchMessages());
      body = chatRoom;
    } else {
      body = new LoadingView();
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text(room.name), actions: [_buildMenu()]),
        body: body,
        floatingActionButton:
            _userHasJoined || messages == null ? null : _joinRoomButton(),
        bottomNavigationBar:
            _userHasJoined && messages != null ? _buildChatInput() : null);
  }

  _fetchMessages() {
    fetchMessagesOfRoom(room.id, messages?.first?.id);
  }

  Widget _buildMenu() => new PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuItem<RoomMenuAction>>[
            new PopupMenuItem<RoomMenuAction>(
                value: RoomMenuAction.leave,
                child: const Text('Leave room')) //todo: intl
          ],
      onSelected: (RoomMenuAction action) {
        switch (action) {
          case RoomMenuAction.leave:
            _onLeaveRoom();
            break;
        }
      });

  _onLeaveRoom() {
    leaveRoom(room).then((success) {
      if (success == true) {
        Navigator.of(context).pop();
      } else {
        // Todo: show error
      }
    });
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

  Widget _buildChatInput() => new ChatInput(
        onSubmit: (String value) async {
          sendMessage(value, room);
        },
      );
}
