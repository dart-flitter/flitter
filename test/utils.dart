import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/redux/store.dart';
import 'package:gitter/gitter.dart';
import 'package:flutter/material.dart';
import 'package:gitter/src/faye.dart';

class MockableApp extends StatelessWidget {
  final Widget drawer;
  final Widget body;
  final AppBar appBar;
  final Widget scaffold;

  MockableApp({this.drawer, this.body, this.appBar, this.scaffold});

  @override
  Widget build(BuildContext context) {
    if (scaffold != null) {
      return new MaterialApp(home: scaffold);
    }
    return new MaterialApp(
        home: new Scaffold(drawer: drawer, body: body, appBar: appBar));
  }
}

initStores() {
  final token = new GitterToken()
    ..access = "xxx"
    ..type = "xxx";
  final api = new GitterApi(token);
  gitterStore = new GitterStore(
      initialState: new GitterState(
          api: api,
          token: token,
          subscriber: new GitterFayeSubscriber(token.access)));

  flitterStore = new FlitterStore(
      initialState: new FlitterAppState(search: new SearchState.initial()),
      middlewares: const []);
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

Iterable<Group> fetchCommunities() {
  flitterStore.dispatch(new FetchGroupsAction(groups));
  return groups;
}

final rooms = <Room>[
  new Room.fromJson({
    "id": "53307860c3599d1de448e19d",
    "name": "Andrew Newdigate",
    "topic": "",
    "oneToOne": true,
    "user": {
      "id": "53307831c3599d1de448e19a",
      "username": "suprememoocow",
      "displayName": "Andrew Newdigate",
      "url": "/suprememoocow",
      "avatarUrlSmall": "https://avatars.githubusercontent.com/u/594566?",
      "avatarUrlMedium": "https://avatars.githubusercontent.com/u/594566?"
    },
    "unreadItems": 0,
    "mentions": 0,
    "lurk": false,
    "url": "/suprememoocow",
    "githubType": "ONETOONE"
  }),
  new Room.fromJson({
    "id": "5330777dc3599d1de448e194",
    "name": "gitterHQ",
    "topic": "Gitter",
    "uri": "gitterHQ",
    "oneToOne": false,
    "userCount": 2,
    "unreadItems": 0,
    "mentions": 0,
    "lastAccessTime": "2014-03-24T18:22:28.105Z",
    "lurk": false,
    "url": "/gitterHQ",
    "githubType": "ORG",
    "v": 1
  }),
  new Room.fromJson({
    "id": "5330780dc3599d1de448e198",
    "name": "gitterHQ/devops",
    "topic": "",
    "uri": "gitterHQ/devops",
    "oneToOne": false,
    "userCount": 2,
    "unreadItems": 0,
    "mentions": 0,
    "lastAccessTime": "2014-03-24T18:23:10.512Z",
    "lurk": false,
    "url": "/gitterHQ/devops",
    "githubType": "ORG_CHANNEL",
    "security": "INHERITED",
    "v": 1
  }),
  new Room.fromJson({
    "id": "53307793c3599d1de448e196",
    "name": "malditogeek/vmux",
    "topic": "VMUX - Plugin-free video calls in your browser using WebRTC",
    "uri": "malditogeek/vmux",
    "oneToOne": false,
    "userCount": 2,
    "unreadItems": 0,
    "mentions": 0,
    "lastAccessTime": "2014-03-24T18:21:08.448Z",
    "favourite": 1,
    "lurk": false,
    "url": "/malditogeek/vmux",
    "githubType": "REPO",
    "tags": ["javascript", "nodejs"],
    "v": 1
  })
];

Iterable<Room> fetchRooms() {
  flitterStore.dispatch(new FetchRoomsAction(rooms));
  return rooms;
}

Iterable<Room> fetchRoomsOfGroup() {
  flitterStore.dispatch(new SelectGroupAction(groups.first));
  flitterStore.dispatch(new FetchRoomsOfGroup(rooms));
  return rooms;
}
