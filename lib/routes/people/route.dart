import 'package:flutter/material.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/common.dart';

class PeoplePage extends StatelessWidget {
  static const path = "/people";

  static PeoplePage builder(BuildContext _) => new PeoplePage();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(intl.people())),
        drawer: new FlitterDrawer());
  }
}
