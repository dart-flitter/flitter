library flitter.routes.people;

import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';

class PeopleView extends StatefulWidget {
  static const String path = "/people";

  static void go(BuildContext context, {bool replace: true}) {
    navigateTo(context, new PeopleView(),
        path: PeopleView.path, replace: replace);
  }

  PeopleView();

  @override
  _PeopleViewState createState() => new _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {

  StreamSubscription _subscription;

  _PeopleViewState() {
    _subscription = flitterStore.onChange.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new LoadingView();

    Widget drawer = new FlitterDrawer(onTapAllConversation: () {
      HomeView.go(context);
    }, onTapPeoples: () {
      Navigator.pop(context);
    });

    String title = intl.people();

    if (flitterStore.state.rooms != null) {
      body = _buildListRooms();
    } else {
      _fetchRooms();
    }

    return new ScaffoldWithSearchbar(
        body: body, title: title, drawer: drawer);
  }

  _buildListRooms() => new ListRoomWidget(
      rooms:
          flitterStore.state.rooms.where((Room room) => room.oneToOne).toList(),
      onRefresh: () {
        return _fetchRooms();
      });

  _fetchRooms() async {
    List<Room> rooms = await gitterApi.user.me.rooms();
    flitterStore.dispatch(new FetchRoomsAction(rooms));
  }
}
