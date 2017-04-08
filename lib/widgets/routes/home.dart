import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/services/gitter/gitter.dart';

class HomeView extends StatefulWidget {
  static final String path = "/home";

  GitterApi api;
  List<Room> rooms;

  HomeView(this.api, this.rooms);

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  Future<Null> onRefresh() async {
    List<Room> rooms = await config.api.user.me.rooms();
    setState(() {
      sortRooms(rooms);
      config.rooms = rooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (config.rooms == null) {
      body = new Center(child: new CircularProgressIndicator());
    } else {
      body = new ListRoomWidget(config.rooms, onRefresh);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          intl.allConversations(),
        ),
      ),
      drawer: new FlitterDrawer(() {
        Navigator.pop(context);
      }, () {
        PageRouteBuilder builder = new PageRouteBuilder(
          settings: new RouteSettings(name: PeopleView.path),
          pageBuilder: (_, __, ___) {
            return new PeopleView(
                config.api, config.rooms);
          },
        );
        Navigator.of(context).pushReplacement(builder);
      }),
      body: body,
    );
  }
}
