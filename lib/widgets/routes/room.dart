import 'package:flitter/widgets/common/chat_room_widget.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/src/models/room.dart';

class RoomView extends StatelessWidget {
  static const path = "/room";

  final Room room;

  RoomView({this.room});

  @override
  Widget build(BuildContext context) {
    if (room == null) {
      return new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    }
    return new Scaffold(
      appBar: new AppBar(title: new Text(room.name)),
      body: new ChatRoomWidget(),
    );
  }
}
