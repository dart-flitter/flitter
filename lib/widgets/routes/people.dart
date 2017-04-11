import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';

class PeopleView extends StatefulWidget {
  static const String path = "/people";

  PeopleView();

  @override
  _PeopleViewState createState() => new _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
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
  Widget build(BuildContext context) {
    var body;

    if (App.of(context).rooms == null) {
      body = new Center(child: new CircularProgressIndicator());
    } else {
      body = new ListRoomWidget(
          rooms: App
              .of(context)
              .rooms
              .where((Room room) => room.oneToOne)
              .toList(),
          onRefresh: () {
            onRefresh(context);
          });
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text(intl.people())),
      body: body,
      drawer: new FlitterDrawer(() {
        navigateTo(
          context,
          new HomeView(),
          path: HomeView.path,
          replace: true,
        );
      }, () {
        Navigator.pop(context);
      }),
    );
  }
}
