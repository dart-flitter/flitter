import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/src/models/room.dart';
import 'package:flitter/common.dart';
import 'package:flitter/routes.dart';

class ListRoomWidget extends StatelessWidget {
  final Iterable<Room> rooms;

  ListRoomWidget(this.rooms);

  @override
  Widget build(BuildContext context) {
    return new ListView(children: _buildListTile(context));
  }

  //////////////

  Row _titleForRoom(Room room) {
    final children = <Widget>[new Expanded(child: new Text(room.name))];

    // todo: if notif
    //children.add(new Chip(label: new Text("42")));

    return new Row(children: children);
  }

  List<ListTile> _buildListTile(BuildContext context) => rooms
      .map((Room room) => new ListTile(
          dense: false,
          title: _titleForRoom(room),
          leading: new Image.network(room.avatarUrl),
          onTap: () {
            navigateTo(context, new RoomView(room), opaque: true);
          }))
      .toList();
}
