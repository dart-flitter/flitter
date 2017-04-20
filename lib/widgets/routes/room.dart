library flitter.routes.room;

import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/chat_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';

enum RoomMenuAction { leave }

class RoomView extends StatefulWidget {
  static const path = "/room";

  final AppState appState;
  final Room room;

  RoomView({@required this.appState, @required this.room});

  @override
  _RoomViewState createState() => new _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  List<Message> messages;
  int _skip;
  int _counter;
  List<Message> _m;

  StreamSubscription<Message> _messageSubscription;

  @override
  void initState() {
    super.initState();
    _skip = 0;
    _counter = 0;
    _m = [];
    messages = [];
    _messageSubscription =
        widget.appState.api.room.onMessage.listen(_onMessage);
    widget.appState.api.room.messagesFromRoomId(widget.room.id, skip: _skip);
  }

  @override
  void dispose() {
    super.dispose();
    _messageSubscription.cancel();
  }

  void _onMessage(Message m) {
    if (_skip == 0) {
      setState(() {
        messages.add(m);
      });
    } else {
      if (_counter < 49) {
        _m.add(m);
      } else {
        _m.addAll(messages);
        setState(() {
          messages = _m;
        });
      }
      _counter++;
    }
  }

  Future<Null> fetchData(BuildContext context) async {
    _skip += 50;
    _counter = 0;
    _m = [];
    App.of(context).api.room.messagesFromRoomId(widget.room.id, skip: _skip);
  }

  @override
  Widget build(BuildContext context) {
    final ChatRoomWidget chatRoom =
        new ChatRoomWidget(messages: messages.reversed.toList());
    chatRoom.onNeedDataStream.listen((_) => fetchData(context));
    Widget body = chatRoom;
    return new Scaffold(
        appBar: new AppBar(
            title: new Text(widget.room.name), actions: [_buildMenu()]),
        body: body,
        floatingActionButton: _userHasJoined ? null : _joinRoomButton(),
        bottomNavigationBar: _userHasJoined ? _buildChatInput() : null);
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
    AppState state = App.of(context);
    state.api.room
        .removeUserFrom(widget.room.id, state.user.id)
        .then((success) {
      if (success == true) {
        state.rooms.removeWhere((Room room) => room.id == widget.room.id);
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
    AppState state = App.of(context);
    state.api.user
        .userJoinRoom(state.user.id, widget.room.id)
        .then((Room room) {
      setState(() {
        state.rooms.add(room);
      });
    });
  }

  bool get _userHasJoined =>
      App.of(context).rooms.any((Room room) => room.id == widget.room.id);

  Widget _buildChatInput() => new ChatInput(
        onSubmit: (String value) async {
          final Message message = await App
              .of(context)
              .api
              .room
              .sendMessageToRoomId(widget.room.id, value);
          setState(() {
            messages.add(message);
          });
        },
      );
}
