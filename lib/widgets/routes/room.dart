library flitter.routes.room;

import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:meta/meta.dart';
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
  List<Message> get messages => flitterStore.state.selectedRoom.messages;
  Room get room => flitterStore.state.selectedRoom.room;

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = flitterStore.onChange.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new LoadingView();
    if (messages == null) {
      _fetchMessages();
    } else {
      final ChatRoomWidget chatRoom =
          new ChatRoomWidget(messages: messages.reversed.toList());
      chatRoom.onNeedDataStream.listen((_) => _fetchMessages());
      body = chatRoom;
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text(room.name), actions: [_buildMenu()]),
        body: body,
        floatingActionButton:
            _userHasJoined || messages == null ? null : _joinRoomButton(),
        bottomNavigationBar:
            _userHasJoined && messages != null ? _buildChatInput() : null);
  }

  Future<Null> _fetchMessages() async {
    gitterApi.room
        .messagesFromRoomId(room.id, beforeId: messages?.first?.id)
        .then((List<Message> messages) {
      flitterStore.dispatch(new OnMessagesForRoom(messages, room.id));
    });
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
    gitterApi.room
        .removeUserFrom(room.id, flitterStore.state.user.id)
        .then((success) {
      if (success == true) {
        flitterStore.dispatch(new LeaveRoomAction(room));
        Navigator.of(context).pop();
      } else {
        // Todo: dispatch error
      }
    });
  }

  Widget _joinRoomButton() {
    return new FloatingActionButton(
        child: new Icon(Icons.message), onPressed: _onTapJoinRoom);
  }

  void _onTapJoinRoom() {
    gitterApi.user
        .userJoinRoom(flitterStore.state.user.id, room.id)
        .then((Room room) {
      flitterStore.dispatch(new JoinRoomAction(room));
    });
  }

  bool get _userHasJoined =>
      flitterStore.state.rooms.any((Room r) => r.id == room.id);

  Widget _buildChatInput() => new ChatInput(
        onSubmit: (String value) async {
          final Message message =
              await gitterApi.room.sendMessageToRoomId(room.id, value);
          flitterStore.dispatch(new OnSendMessage(message, room.id));
        },
      );
}
