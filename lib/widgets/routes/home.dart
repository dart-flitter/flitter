import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/src/models/room.dart';
import 'package:flitter/app_state.dart';

class HomeView extends StatefulWidget {
  static const path = "/";

  static HomeView builder(BuildContext _) => new HomeView();

  final AppState appState = new AppState();

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {
    var body;

    if (config.appState.rooms == null) {
      body = new Center(child: new CircularProgressIndicator());
    } else {
      body = new ListRoomWidget(config.appState.rooms);
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text(intl.allConversations())),
        body: body,
        drawer: new FlitterDrawer());
  }

  @override
  void initState() {
    super.initState();
    config.appState.gApi.user.me.rooms().then((List rooms) {
      setState(() {
        config.appState.rooms = rooms;
      });
    });
  }
}
