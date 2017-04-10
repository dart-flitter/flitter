import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/services/gitter/gitter.dart';
import 'package:meta/meta.dart';
import 'package:flitter/app.dart';

class HomeView extends StatefulWidget {
  static final String path = "/home";

  final AppState app;

  HomeView({@required this.app});

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<Null> onRefresh() async {
    List<Room> rooms = await config.app.api.user.me.rooms();
    if (!mounted) {
      return;
    }
    setState(() {
      config.app.rooms = rooms;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          intl.allConversations(),
        ),
      ),
      drawer: new FlitterDrawer(() {
        Navigator.pop(context);
      }, () {
        navigateTo(
          context,
          new PeopleView(app: config.app),
          path: PeopleView.path,
          replace: true,
        );
      }),
      body: new ListRoomWidget(config.app, config.app.rooms, onRefresh),
    );
  }
}
