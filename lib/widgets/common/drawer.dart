import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter/painting.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/auth.dart';
import 'package:flitter/routes.dart';

class FlitterDrawer extends StatelessWidget {
  VoidCallback onTapAllConversation;
  VoidCallback onTapPeoples;

  FlitterDrawer(
      {@required this.onTapAllConversation, @required this.onTapPeoples});

  @override
  Widget build(BuildContext context) {
    final child = [
      _getUserAndBuildDrawerHeader(context),
      new ListTile(
          leading: new Icon(Icons.home),
          title: new Text(intl.allConversations()),
          onTap: onTapAllConversation),
      new ListTile(
          leading: new Icon(Icons.person),
          title: new Text(intl.people()),
          onTap: onTapPeoples),
    ];

    child.addAll(_drawerCommunities());
    child.addAll(_drawerFooter(context));

    return new Drawer(child: new ListView(children: child));
  }

  final _gitterBannerUrl =
      "https://cdn02.gitter.im/_s/a321a0b/images/home/banner.jpg";

  ////////

  List<Widget> _drawerCommunities() {
    final communities = [
      new Divider(),
      new Padding(
          padding: new EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: new Text(intl.communities())),
    ];

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
                  image: new NetworkImage(_gitterBannerUrl),
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
}
