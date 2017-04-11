import 'package:meta/meta.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/chat_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';

class RoomView extends StatefulWidget {
  static const path = "/room";

  final Room room;

  RoomView({@required this.room});

  @override
  _RoomViewState createState() => new _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  List<Message> _messages;

  void initState() {
    super.initState();
    _messages = [];
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
    if (_messages.isEmpty) {
      body = new FutureBuilder<List<Message>>(
        future: App.of(context).api.room.messagesFromRoomId(config.room.id),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            if (_messages == null) {
              return new Center(child: new CircularProgressIndicator());
            } else {
              return new ChatRoomWidget(_messages);
            }
          }
          final List<Message> messages = snapshot.data.toList();
          _messages = messages;
          return new ChatRoomWidget(_messages.reversed.toList());
        },
      );
    } else {
      body = new ChatRoomWidget(_messages.reversed.toList());
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text(config.room.name)),
      body: body,
      bottomNavigationBar: new ChatInput(
        onSubmit: (String value) async {
          final Message message = await App
              .of(context)
              .api
              .room
              .sendMessageToRoomId(config.room.id, value);
          setState(() {
            _messages.add(message);
          });
        },
      ),
    );
  }
}
