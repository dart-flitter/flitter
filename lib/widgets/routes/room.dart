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
  List<Message> _messages;

  @override
  Widget build(BuildContext context) {
    if (config.room == null) {
      return new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text(config.room.name)),
      body: new FutureBuilder<List<Message>>(
        future: config.api.room.messagesFromRoomId(config.room.id),
        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            if (_messages == null) {
              return new Center(child: new CircularProgressIndicator());
            } else {
              return new ChatRoomWidget(_messages);
            }
          }
          final List<Message> messages = snapshot.data.reversed.toList();
          _messages = messages;
          return new ChatRoomWidget(messages);
        },
      ),
      bottomNavigationBar: new ChatInput(
        onSubmit: (String value) async {
          await config.api.room.sendMessageToRoomId(config.room.id, value);
          setState(() {});
        },
      ),
    );
  }
}
