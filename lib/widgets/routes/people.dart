import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class PeopleView extends StatefulWidget {
  static const String path = "/people";

  GitterApi api;
  List<Room> rooms;

  PeopleView(this.api, this.rooms);

  @override
  _PeopleViewState createState() => new _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  Future<Null> onRefresh() async {
    List<Room> rooms = await config.api.user.me.rooms();
    sortRooms(rooms);
    if (!mounted) {
      return;
    }
    setState(() {
      config.rooms = rooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    var body;

    if (config.rooms == null) {
      body = new Center(child: new CircularProgressIndicator());
    } else {
      body = new ListRoomWidget(
          config.rooms.where((Room room) => room.oneToOne).toList(), onRefresh);
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text(intl.people())),
      body: body,
      drawer: new FlitterDrawer(() {
        navigateTo(
          context,
          new HomeView(config.api, config.rooms),
          path: HomeView.path,
          replace: true,
        );
      }, () {
        Navigator.pop(context);
      }),
    );
  }
}
