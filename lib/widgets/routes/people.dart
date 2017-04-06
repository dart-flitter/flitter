import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/gitter/src/models/room.dart';
import 'package:flitter/auth.dart';

class PeopleView extends StatefulWidget {
  static const path = "/people";

  static PeopleView builder(BuildContext _) => new PeopleView();

  @override
  _PeopleViewState createState() => new _PeopleViewState();
}

class _PeopleViewState extends State<PeopleView> {
  List<Room> _rooms;

  @override
  Widget build(BuildContext context) {
    var body;

    if (_rooms == null) {
      _fetchRooms().then((List rooms) {
        setState(() {
          _rooms = rooms;
        });
      });
      body = new Center(child: new CircularProgressIndicator());
    } else {
      body = new ListRoomWidget(_rooms);
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text(intl.people())),
        body: body,
        drawer: new FlitterDrawer());
  }

  ////////

  Future<List<Room>> _fetchRooms() async {
    final token = await auth();
    final api = new GitterApi(token);
    final rooms = await api.user.me.rooms();
    return rooms.where((Room room) => room.oneToOne).toList();
  }
}
