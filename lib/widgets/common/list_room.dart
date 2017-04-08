import 'package:flitter/widgets/routes/room.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/src/models/room.dart';

class ListRoomWidget extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final List<Room> rooms;
  final RefreshCallback onRefresh;

  ListRoomWidget(this.rooms, this.onRefresh);

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      child: new ListView.builder(
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
      leading: new Image.network(room.avatarUrl),
      trailing: room.unreadItems > 0
          ? new Chip(label: new Text("${room.unreadItems}"))
          : null,
      onTap: () {
        MaterialPageRoute route = new MaterialPageRoute(
          settings: new RouteSettings(name: RoomView.path),
          builder: (BuildContext context) => new RoomView(room),
        );
        Navigator.push(context, route);
      },
    );
  }
}
