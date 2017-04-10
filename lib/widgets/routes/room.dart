import 'dart:async';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/chat_room_widget.dart';
import 'package:flutter/material.dart';

class RoomView extends StatefulWidget {
  static const path = "/room";

  final GitterApi api;
  final Room room;

  RoomView(this.api, {this.room});

  @override
  _RoomViewState createState() => new _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  List<Message> messages;
  int _skip;
  int _counter;
  List<Message> _m;

  @override
  void initState() {
    super.initState();
    _skip = 0;
    _counter = 0;
    messages = [];
    _m = [];
    config.api.room.onMessage.listen(_onMessage);
    config.api.room.messagesFromRoomId(config.room.id, skip: _skip);
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

  Future<Null> fetchData() async {
    _skip += 50;
    _counter = 0;
    _m = [];
    config.api.room.messagesFromRoomId(config.room.id, skip: _skip);
  }

  @override
  Widget build(BuildContext context) {
    if (config.room == null) {
      return new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    }
    Widget body;
    if (messages.isEmpty) {
      body = new Center(child: new CircularProgressIndicator());
    } else {
      final ChatRoomWidget chatRoom =
          new ChatRoomWidget(messages: messages.reversed.toList());
      chatRoom.onNeedData.listen((_) => fetchData());
      body = chatRoom;
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text(config.room.name)),
      body: body,
      bottomNavigationBar: new ChatInput(
        onSubmit: (String value) async {
          final Message message =
              await config.api.room.sendMessageToRoomId(config.room.id, value);
          setState(() {
            messages.add(message);
          });
        },
      ),
    );
  }
}
