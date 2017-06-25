library flitter.routes.group_room;

import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/common/utils.dart';
import 'package:flitter/widgets/routes/settings.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flitter/app.dart';

class GroupView extends StatefulWidget {
  static const path = "/group";

  static go(BuildContext context, Group group, {bool replace: true}) {
    fetchRoomsOfGroup();
    materialNavigateTo(context, new GroupView(),
        path: GroupView.path, replace: replace);
  }

  @override
  _GroupRoomViewState createState() => new _GroupRoomViewState();
}

class _GroupRoomViewState extends State<GroupView> {
  var _subscription;

  CurrentGroupState get groupState => flitterStore.state.selectedGroup;

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

    if (groupState?.rooms != null) {
      body = new ListView(
          children: groupState.rooms
              .map((room) => new RoomTile(room: room))
              .toList());
    } else {
      body = new LoadingView();
    }

    return new Scaffold(
      appBar: new AppBar(title: new Text(groupState?.group?.name ?? "")),
      body: body,
      drawer: new FlitterDrawer(onTapAllConversation: () {
        HomeView.go(context);
      }, onTapPeoples: () {
        PeopleView.go(context);
      }, onTapSettings: () {
        SettingsView.go(context);
      }),
    );
  }
}
