import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/common.dart';
import 'package:flitter/models.dart';

class HomeView extends StatelessWidget {
  static const path = "/";

  static HomeView builder(BuildContext _) => new HomeView();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(intl.allConversations())),
        body: new ListRoomWidget(_listRooms()),
        drawer: new FlitterDrawer());
  }

  ////////////////

  List<Room> _listRooms() => [
        new Room("flutter/flutter",
            "https://avatars3.githubusercontent.com/u/14101776?v=3&s=200"),
        new Room("dart-lang/sdk",
            "https://avatars3.githubusercontent.com/u/1609975?v=3&s=200"),
        new Room("dart-lang/server",
            "https://avatars3.githubusercontent.com/u/1609975?v=3&s=200")
      ];
}
