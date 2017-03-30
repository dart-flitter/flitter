import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/common.dart';

class Home extends StatelessWidget {
  static const path = "/";

  static Home builder(BuildContext _) => new Home();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(intl.allConversations())),
        body: new ChatRoomWidget(),
        bottomNavigationBar: new ChatInput(onSaved: (InputValue v) {}),
        drawer: new FlitterDrawer());
  }
}
