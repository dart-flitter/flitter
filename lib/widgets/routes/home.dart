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

  HomeView();

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<Null> onRefresh(BuildContext context) async {
    List<Room> rooms = await App.of(context).api.user.me.rooms();
    if (!mounted) {
      return;
    }
    setState(() {
      App.of(context).rooms = rooms;
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
          new PeopleView(),
          path: PeopleView.path,
          replace: true,
        );
      }),
      body: new ListRoomWidget(
          rooms: App.of(context).rooms,
          onRefresh: () {
            onRefresh(context);
          }),
    );
  }
}
