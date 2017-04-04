import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/common.dart';
import 'package:flitter/models.dart';

class RoomView extends StatelessWidget {
  static const path = "/room";
  static RoomView builder(BuildContext _) => new RoomView(null);

  final Room room;

  RoomView(this.room);

  @override
  Widget build(BuildContext context) {
    if (room == null) {
      return new Scaffold(
          appBar: new AppBar(),
          body: new Center(child: new CircularProgressIndicator()));
    }
    return new Scaffold(appBar: new AppBar(title: new Text(room.name)));
  }
}
