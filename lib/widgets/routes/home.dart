library flitter.routes.home;

import 'dart:async';

import 'package:flitter/common.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/app.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class HomeView extends StatefulWidget {
  static final String path = "/home";

  HomeView();

  static void go(BuildContext context, {bool replace: true}) {
    navigateTo(context, new HomeView(), path: HomeView.path, replace: replace);
  }

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription _subscription;

  _HomeViewState() {
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
      Navigator.pop(context);
    }, onTapPeoples: () {
      PeopleView.go(context);
    });

    String title = intl.allConversations();

    if (flitterStore.state.rooms != null) {
      body = _buildListRooms();
    } else {
      _fetchRooms();
    }

    return new ScaffoldWithSearchbar(
        body: body, title: title, drawer: drawer);
  }

  _fetchRooms() async {
    List<Room> rooms = await gitterApi.user.me.rooms();
    flitterStore.dispatch(new FetchRoomsAction(rooms));
  }


  _buildListRooms() =>
      new ListRoomWidget(
          rooms: flitterStore.state.rooms,
          onRefresh: () {
            return _fetchRooms();
          });
}
