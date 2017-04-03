import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/routes.dart';
import 'package:flitter/common.dart';

class FlitterDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(children: [
      new DrawerHeader(child: new Container()),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: () {
            navigateTo(context, new HomeView(), replace: true);
          }),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: () {
            navigateTo(context, new PeopleView(), replace: true);
          }),
      new Divider(),
    ]));
  }
}
