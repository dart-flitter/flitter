library flitter.routes.home;

import 'dart:async';

import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/common/search.dart';
import 'package:flitter/widgets/common/utils.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flitter/widgets/routes/settings.dart';
import 'package:flutter/material.dart';
import 'package:flitter/app.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class HomeView extends StatefulWidget {
  static final String path = "/";
  final RefreshCallback onRefresh;

  static void go(BuildContext context, {bool replace: true}) {
    fetchRooms();
    materialNavigateTo(context, new HomeView(),
        path: HomeView.path, replace: replace);
  }

  HomeView({this.onRefresh});

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
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
    var body;

    final drawer = new FlitterDrawer(onTapAllConversation: () {
      Navigator.pop(context);
    }, onTapPeoples: () {
      PeopleView.go(context);
    }, onTapSettings: () {
      SettingsView.go(context);
    });

    if (flitterStore.state.rooms != null) {
      body = new ListRoom(
          rooms: flitterStore.state.rooms,
          onRefresh: () {
            if (widget.onRefresh != null) {
              return widget.onRefresh();
            }
            return fetchRooms();
          });
    } else {
      body = new LoadingView();
    }

    return new ScaffoldWithSearchbar(
        body: body, title: intl.allConversations(), drawer: drawer);
  }
}
