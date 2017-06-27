library flitter.common.drawer;

import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_auth.dart';
import 'package:flitter/widgets/routes/settings.dart';
import 'package:flutter/src/rendering/sliver.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/widgets/routes/group.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

class FlitterDrawer extends StatefulWidget {
  final VoidCallback onTapAllConversation;
  final VoidCallback onTapPeoples;
  final VoidCallback onTapSettings;

  FlitterDrawer(
      {@required this.onTapAllConversation,
      @required this.onTapPeoples,
      @required this.onTapSettings});

  @override
  _FlitterDrawerState createState() => new _FlitterDrawerState();
}

class _FlitterDrawerState extends State<FlitterDrawer> {
  var _subscription;

  @override
  Widget build(BuildContext context) {
    if (flitterStore.state.user != null) {
      return new Drawer(
          child: new FlitterDrawerContent(
              onTapAllConversation: widget.onTapAllConversation,
              onTapPeoples: widget.onTapPeoples,
              onTapSettings: widget.onTapSettings));
    }
    return new Center(child: new CircularProgressIndicator());
  }

  ////////

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

class FlitterDrawerContent extends StatelessWidget {
  final VoidCallback onTapAllConversation;
  final VoidCallback onTapPeoples;
  final VoidCallback onTapSettings;

  FlitterDrawerContent(
      {@required this.onTapAllConversation,
      @required this.onTapPeoples,
      @required this.onTapSettings});

  @override
  Widget build(BuildContext context) {
    final child = <Widget>[
      new FlitterDrawerHeader(),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: onTapAllConversation),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: onTapPeoples),
      new ListTile(
          leading: new Icon(Icons.settings),
          title: new Text(intl.settings()),
          onTap: onTapSettings)
    ];
    child.addAll(_drawerCommunities(context));
    child.addAll(_drawerFooter(context));
    return new ListView(children: child);
  }

  Iterable<Widget> _drawerCommunities(BuildContext context) {
    final communities = <Widget>[
      new Divider(),
      new ListTile(title: new Text(intl.communities()), dense: true)
    ];

    communities.addAll(_buildCommunities(context));
    return communities;
  }

  Iterable<Widget> _drawerFooter(BuildContext context) =>
      [new Divider(), new FlitterDrawerFooter()];

  Iterable<Widget> _buildCommunities(BuildContext context) {
    if (flitterStore.state.groups == null) {
      return <Widget>[];
    }
    return flitterStore.state.groups.map((group) {
      return new FlitterDrawerCommunityTile(group: group);
    }).toList();
  }
}

class FlitterDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new UserAccountsDrawerHeader(
        accountName: new Text(flitterStore.state.user.username),
        accountEmail: new Text(flitterStore.state.user.displayName),
        currentAccountPicture: new CircleAvatar(
            backgroundImage:
                new NetworkImage(flitterStore.state.user.avatarUrlMedium)),
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage('assets/images/banner.jpg'),
                fit: BoxFit.cover)));
  }
}

class FlitterDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListTile(
        leading: new Icon(Icons.exit_to_app),
        title: new Text(intl.logout()),
        onTap: () {
          Navigator.of(context).pop();
          FlitterAuth.logout();
        });
  }
}

class FlitterDrawerCommunityTile extends StatelessWidget {
  final Group group;

  FlitterDrawerCommunityTile({@required this.group});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        dense: false,
        title: new Text(group.name),
        leading: new CircleAvatar(
            backgroundImage: new NetworkImage(group.avatarUrl),
            backgroundColor: Theme.of(context).canvasColor),
        trailing: null,
        //TODO: unread inside roomsOf(group)
        onTap: () {
          flitterStore.dispatch(new SelectGroupAction(group));
          GroupView.go(context, group);
        });
  }
}
