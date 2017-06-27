library flitter.common.list_room;

import 'package:flitter/widgets/common/utils.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/store.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/widgets/routes/room.dart';
import 'package:flitter/redux/actions.dart';

class ListRoom extends StatelessWidget {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final Iterable<Room> rooms;
  final RefreshCallback onRefresh;

  ListRoom({@required this.rooms, @required this.onRefresh});

  @override
  Widget build(BuildContext context) {
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
          backgroundImage:
              room.avatarUrl != null ? new NetworkImage(room.avatarUrl) : null,
          backgroundColor: Theme.of(context).canvasColor),
      trailing: room?.unreadItems != null && room.unreadItems > 0
          ? new MessageCount(room.unreadItems)
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
      onTap: () async {
        final Room room = await gitterApi.room.roomFromUri(user.url);
        flitterStore.dispatch(new SelectRoomAction(room));
        materialNavigateTo(context, new RoomView(), path: RoomView.path);
      },
    );
  }
}

class MessageCount extends StatelessWidget {
  final int count;

  MessageCount(this.count);

  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Container(
          decoration: new BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: new BorderRadius.circular(16.0)),
          padding:
              new EdgeInsets.only(left: 6.0, right: 6.0, top: 4.0, bottom: 4.0),
          child: new DefaultTextStyle(
              style: new TextStyle(fontSize: 10.0), child: new Text("$count")))
    ]);
  }
}
