import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flutter/material.dart';

class MockableApp extends StatelessWidget {
  final Widget drawer;

  MockableApp({this.drawer});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new Scaffold(drawer: drawer));
  }
}

initFlitterStore() {
  final token = new GitterToken()
    ..access = "xxx"
    ..type = "xxx";
  final api = new GitterApi(token);

  flitterStore = new FlitterStore(
      initialState: new FlitterAppState(api: api, token: token));
}

fetchUser() {
  final user = new User.fromJson({
    "id": "53307734c3599d1de448e192",
    "username": "malditogeek",
    "displayName": "Mauro Pompilio",
    "url": "/malditogeek",
    "avatarUrlSmall": "https://avatars.githubusercontent.com/u/14751?",
    "avatarUrlMedium": "https://avatars.githubusercontent.com/u/14751?"
  });
  flitterStore.dispatch(new FetchUser(user));
}

fetchCommunities() {
  final groups = <Group>[
    new Group.fromJson({
      "id": "57542c12c43b8c601976fa66",
      "name": "gitterHQ",
      "uri": "gitterHQ",
      "backedBy": {"type": "GH_ORG", "linkPath": "gitterHQ"},
      "avatarUrl":
          "http://gitter.im/api/private/avatars/group/i/577ef7e4e897e2a459b1b881"
    }),
    new Group.fromJson({
      "id": "577faf61a7d5727908337209",
      "name": "i-love-cats",
      "uri": "i-love-cats",
      "backedBy": {"type": null},
      "avatarUrl":
          "http://gitter.im/api/private/avatars/group/i/577faf61a7d5727908337209"
    })
  ];
  flitterStore.dispatch(new FetchGroupsAction(groups));
}
