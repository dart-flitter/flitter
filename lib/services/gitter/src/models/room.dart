library gitter.room;

import 'package:flitter/services/gitter/src/models/user.dart';

class Room {
  final String id;
  final String name;
  final String topic;
  final String uri;
  final bool oneToOne;
  final num userCount;
  final User user;
  final num unreadItems;
  final num mentions;
  final String lastAccessTime;
  final bool lurk;
  final String url;
  final String githubType;
  final List<String> tags;
  final num v;

  Room.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        topic = json['topic'],
        uri = json['uri'],
        oneToOne = json['oneToOne'],
        userCount = json['userCount'],
        user =
            json.containsKey('user') ? new User.fromJson(json['user']) : null,
        unreadItems = json['unreadItems'],
        mentions = json['mentions'],
        lastAccessTime = json['lastAccessTime'],
        lurk = json['lurk'],
        url = json['url'],
        githubType = json['githubType'],
        tags = json.containsKey('tags') ? json['tags'] : [],
        v = json['v'];

  @override
  String toString() => "$id $name";
}
