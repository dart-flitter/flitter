import 'dart:async';

import 'package:meta/meta.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/common.dart';
import 'package:flitter/routes.dart';

class GroupRoomView extends StatefulWidget {
  static const path = "/group";

  final AppState appState;
  final Group group;

  static go(BuildContext context, Group group, {bool replace: true}) {
    navigateTo(
        context, new GroupRoomView(appState: App.of(context), group: group),
        path: GroupRoomView.path, replace: replace);
  }

  GroupRoomView({@required this.appState, @required this.group});

  @override
  _GroupRoomViewState createState() => new _GroupRoomViewState();
}

class _GroupRoomViewState extends State<GroupRoomView> {
  List<Room> _rooms;

  @override
  void initState() {
    super.initState();
  }

  Future<Null> fetchData(BuildContext context) async {
    final rooms = await App.of(context).api.group.roomsOf(config.group.id);
    setState(() {
      _rooms = rooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new Center(
      child: new CircularProgressIndicator(),
    );
    if (_rooms == null) {
      fetchData(context);
    } else {
      final children = [];

      children.addAll(_rooms.map((room) => roomTile(context, room)).toList());

      body = new ListView(children: children);
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text(config.group.name)),
      body: body,
      drawer: new FlitterDrawer(onTapAllConversation: () {
        HomeView.go(context);
      }, onTapPeoples: () {
        PeopleView.go(context);
      }),
    );
  }
}
