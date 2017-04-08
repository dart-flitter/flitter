import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class FlitterDrawer extends StatelessWidget {
  VoidCallback onTapAllConversation;
  VoidCallback onTapPeoples;

  FlitterDrawer(this.onTapAllConversation, this.onTapPeoples);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(children: [
      new DrawerHeader(child: new Container()),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: onTapAllConversation),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: onTapPeoples),
      new Divider(),
    ]));
  }
}
