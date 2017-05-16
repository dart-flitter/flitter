library flitter.common.drawer;

import 'dart:async';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/widgets/routes/group_room.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class FlitterDrawer extends StatefulWidget {
  final VoidCallback onTapAllConversation;
  final VoidCallback onTapPeoples;

  FlitterDrawer(
      {@required this.onTapAllConversation, @required this.onTapPeoples});

  @override
  _FlitterDrawerState createState() => new _FlitterDrawerState();
}

class _FlitterDrawerState extends State<FlitterDrawer> {
  StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    if (flitterStore.state.user != null) {
      final child = [
        _buildDrawerHeader(context),
        new ListTile(
            leading: new Icon(Icons.home),
            title: new Text(intl.allConversations()),
            onTap: widget.onTapAllConversation),
        new ListTile(
            leading: new Icon(Icons.person),
            title: new Text(intl.people()),
            onTap: widget.onTapPeoples),
      ];

      child.addAll(_drawerCommunities(context));
      child.addAll(_drawerFooter(context));
      return new Drawer(child: new ListView(children: child));
    }
    return new Center(child: new CircularProgressIndicator());
  }

  ////////

  Iterable<Widget> _drawerCommunities(BuildContext context) {
    final communities = <Widget>[
      new Divider(),
      new ListTile(title: new Text(intl.communities()), dense: true)
    ];

    communities.addAll(_buildCommunities(context));

    return communities;
  }

  Iterable<Widget> _drawerFooter(BuildContext context) => [
        new Divider(),
        new ListTile(
            leading: new Icon(Icons.exit_to_app),
            title: new Text(intl.logout()),
            onTap: () {
              Navigator.of(context).pop();
              FlitterAuth.logout();
            }),
      ];

  Widget _buildDrawerHeader(BuildContext context) =>
      new UserAccountsDrawerHeader(
          accountName: new Text(flitterStore.state.user.username),
          accountEmail: new Text(flitterStore.state.user.displayName),
          currentAccountPicture: new CircleAvatar(
              backgroundImage:
                  new NetworkImage(flitterStore.state.user.avatarUrlMedium)),
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage('assets/images/banner.jpg'),
                  fit: BoxFit.cover)));

  Iterable<Widget> _buildCommunities(BuildContext context) {
    if (flitterStore.state.groups == null) {
      return [];
    }
    return flitterStore.state.groups.map((group) {
      return new ListTile(
          dense: false,
          title: new Text(group.name),
          leading: new CircleAvatar(
              backgroundImage: new NetworkImage(group.avatarUrl),
              backgroundColor: Theme.of(context).canvasColor),
          trailing: null, //TODO: unread inside roomsOf(group)
          onTap: () {
            flitterStore.dispatch(new SelectGroupAction(group));
            GroupRoomView.go(context, group);
          });
    }).toList();
  }

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
}
