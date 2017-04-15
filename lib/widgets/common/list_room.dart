import 'package:meta/meta.dart';
import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/room.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';

class ListRoomWidget extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final List<Room> rooms;
  final RefreshCallback onRefresh;

  ListRoomWidget({@required this.rooms, @required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        key: _refreshIndicatorKey,
        itemCount: rooms.length,
        itemBuilder: _buildListTile,
      ),
      onRefresh: onRefresh,
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    final Room room = rooms[index];
    return new ListTile(
      dense: false,
      title: new Text(room.name),
      leading: new CircleAvatar(
          backgroundImage: new NetworkImage(room.avatarUrl),
          backgroundColor: Theme.of(context).canvasColor),
      trailing: room.unreadItems > 0
          ? new Chip(label: new Text("${room.unreadItems}"))
          : null,
      onTap: () {
        materialNavigateTo(
            context, new RoomView(appState: App.of(context), room: room),
            path: RoomView.path);
      },
    );
  }
}

Widget roomTile(BuildContext context, Room room) => new ListTile(
      dense: false,
      title: new Text(room.name),
      leading: new CircleAvatar(
          backgroundImage: new NetworkImage(room.avatarUrl),
          backgroundColor: Theme.of(context).canvasColor),
      trailing: room?.unreadItems != null && room.unreadItems > 0
          ? new Chip(label: new Text("${room.unreadItems}"))
          : null,
      onTap: () {
        materialNavigateTo(
            context, new RoomView(appState: App.of(context), room: room),
            path: RoomView.path);
      },
    );
