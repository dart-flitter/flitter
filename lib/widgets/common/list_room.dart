library flitter.common.list_room;

import 'package:flitter/widgets/common/utils.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/room.dart';
import 'package:flitter/redux/actions.dart';

class ListRoomWidget extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final Iterable<Room> rooms;
  final RefreshCallback onRefresh;

  ListRoomWidget({@required this.rooms, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (onRefresh == null) {
      return new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        key: _refreshIndicatorKey,
        itemCount: rooms.length,
        itemBuilder: _buildListTile,
      );
    }
    return new RefreshIndicator(
        child: new ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          key: _refreshIndicatorKey,
          itemCount: rooms.length,
          itemBuilder: _buildListTile,
        ),
        onRefresh: onRefresh);
  }

  Widget _buildListTile(BuildContext context, int index) {
    return new RoomTile(room: rooms.elementAt(index));
  }
}

class RoomTile extends StatelessWidget {
  final Room room;

  RoomTile({@required this.room});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      dense: false,
      title: new Text(room.name),
      leading: new CircleAvatar(
          backgroundImage: new NetworkImage(room.avatarUrl),
          backgroundColor: Theme.of(context).canvasColor),
      trailing: room?.unreadItems != null && room.unreadItems > 0
          ? new Chip(label: new Text("${room.unreadItems}"))
          : null,
      onTap: () {
        flitterStore.dispatch(new SelectRoomAction(room));
        materialNavigateTo(context, new RoomView(), path: RoomView.path);
      },
    );
  }
}

class UserTile extends StatelessWidget {
  final User user;

  UserTile({@required this.user});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      dense: false,
      title: new Text(user.username),
      leading: new CircleAvatar(
          backgroundImage: new NetworkImage(user.avatarUrlSmall),
          backgroundColor: Theme.of(context).canvasColor),
      onTap: () {
        gitterApi.room.roomFromUri(user.url).then((Room room) {
          flitterStore.dispatch(new SelectRoomAction(room));
          materialNavigateTo(context, new RoomView(), path: RoomView.path);
        });
      },
    );
  }
}
