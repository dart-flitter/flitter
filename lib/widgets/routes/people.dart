library flitter.routes.people;

import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/common/search.dart';
import 'package:flitter/widgets/routes/settings.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/utils.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';

class PeopleView extends StatefulWidget {
  static const String path = "/people";
  final RefreshCallback onRefresh;

  static void go(BuildContext context, {bool replace: true}) {
    fetchRooms();
    materialNavigateTo(context, new PeopleView(),
        path: PeopleView.path, replace: replace);
  }

  PeopleView({this.onRefresh});

  @override
  _PeopleViewState createState() => new _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  var _subscription;

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
      HomeView.go(context);
    }, onTapPeoples: () {
      Navigator.pop(context);
    }, onTapSettings: () {
      SettingsView.go(context);
    });

    if (flitterStore.state.rooms != null) {
      body = new ListRoom(
          rooms: flitterStore.state.rooms
              .where((Room room) => room.oneToOne)
              .toList(),
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
        body: body, title: intl.people(), drawer: drawer);
  }
}
