library flitter.routes.group_room;

import 'dart:async';

import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/common.dart';

class GroupRoomView extends StatefulWidget {
  static const path = "/group";

  static go(BuildContext context, Group group, {bool replace: true}) {
    navigateTo(context, new GroupRoomView(),
        path: GroupRoomView.path, replace: replace);
  }

  GroupRoomView();

  @override
  _GroupRoomViewState createState() => new _GroupRoomViewState();
}

class _GroupRoomViewState extends State<GroupRoomView> {
  StreamSubscription _subscription;

  CurrentGroupState get groupState => flitterStore.state.selectedGroup;

  @override
  void initState() {
    super.initState();
    _subscription = flitterStore.onChange.listen((_) {
      setState(() {});
    });

    if (groupState.rooms == null) {
      fetchRoomsOfGroup();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (groupState?.rooms != null) {
      final children = [];

      children.addAll(
          groupState.rooms.map((room) => roomTile(context, room)).toList());

      body = new ListView(children: children);
    } else {
      body = new LoadingView();
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text(groupState.group.name)),
      body: body,
      drawer: new FlitterDrawer(onTapAllConversation: () {
        HomeView.go(context);
      }, onTapPeoples: () {
        PeopleView.go(context);
      }),
    );
  }
}
