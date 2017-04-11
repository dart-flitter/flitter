import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/auth.dart';
import 'package:flitter/routes.dart';
import 'package:flitter/common.dart';

class FlitterDrawer extends StatefulWidget {
  VoidCallback onTapAllConversation;
  VoidCallback onTapPeoples;

  FlitterDrawer(
      {@required this.onTapAllConversation, @required this.onTapPeoples});

  @override
  _FlitterDrawerState createState() => new _FlitterDrawerState();
}

class _FlitterDrawerState extends State<FlitterDrawer> {
  @override
  Widget build(BuildContext context) {
    final child = [
      _getUserAndBuildDrawerHeader(context),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: config.onTapAllConversation),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: config.onTapPeoples),
    ];

    child.addAll(_drawerCommunities(context));
    child.addAll(_drawerFooter(context));

    return new Drawer(child: new ListView(children: child));
  }

  ////////

  List<Widget> _drawerCommunities(BuildContext context) {
    final communities = [
      new Divider(),
      new Padding(
          padding: new EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: new Text(intl.communities())),
    ];

    communities.addAll(_getGroupsAndBuildCommunities(context));

    return communities;
  }

  List<Widget> _drawerFooter(BuildContext context) => [
        new Divider(),
        new ListTile(
            leading: new Icon(Icons.exit_to_app),
            title: new Text(intl.logout()),
            onTap: () {
              logout(context).then((_) {
                LoginView.go(context);
              });
            }),
      ];

  Widget _buildDrawerHeader(BuildContext context) =>
      new UserAccountsDrawerHeader(
          accountName: new Text(App.of(context).user.username),
          accountEmail: new Text(App.of(context).user.displayName),
          currentAccountPicture: new CircleAvatar(
              backgroundImage:
                  new NetworkImage(App.of(context).user.avatarUrlMedium)),
          decoration: new BoxDecoration(
              backgroundImage: new BackgroundImage(
                  image: new AssetImage('assets/images/banner.jpg'),
                  fit: BoxFit.cover)));

  Widget _getUserAndBuildDrawerHeader(BuildContext context) {
    if (App.of(context).user != null) {
      return _buildDrawerHeader(context);
    }
    return new FutureBuilder<User>(
      future: App.of(context).api.user.me.get(),
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return new Drawer(
              child: new Container(
                  child: new Center(child: new CircularProgressIndicator())));
        }
        App.of(context).user = snapshot.data;
        return _buildDrawerHeader(context);
      },
    );
  }

  List<Widget> _buildCommunities(BuildContext context) {
    return App.of(context).groups.map((group) {
      return new ListTile(
          dense: false,
          title: new Text(group.name),
          leading: new CircleAvatar(
              backgroundImage: new NetworkImage(group.avatarUrl),
              backgroundColor: Theme.of(context).canvasColor),
          trailing: null, //TODO: unread inside roomsOf(group)
          onTap: () {
            GroupRoomView.go(context, group);
          });
    }).toList();
  }

  List<Widget> _getGroupsAndBuildCommunities(BuildContext context) {
    if (App.of(context).groups != null) {
      return _buildCommunities(context);
    }
    App.of(context).api.group.get().then((groups) {
      setState(() {
        App.of(context).groups = groups;
      });
    });
    return [
      new Container(child: new Center(child: new CircularProgressIndicator()))
    ];
  }
}
