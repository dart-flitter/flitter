library gitter.message;

import 'package:flitter/services/gitter/src/models/issue.dart';
import 'package:flitter/services/gitter/src/models/mention.dart';
import 'package:flitter/services/gitter/src/models/user.dart';

class Message {
  final String id;
  final String text;
  final String html;
  final String sent;
  final String editedAt;
  final User fromUser;
  final bool unread;
  final int readBy;
  final List<String> urls;
  final List<Mention> mentions;
  final List<Issue> issues;
//  not used right now
//  final meta;
  final int v;
//  final gv;

  Message.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        html = json['html'],
        sent = json['sent'],
        editedAt = json['editedAt'],
        fromUser = json.containsKey('fromUser')
            ? new User.fromJson(json['fromUser'])
            : null,
        unread = json['usnread'],
        readBy = json['readBy'],
        urls = json['urls'],
        mentions = json.containsKey('mentions')
            ? (json['mentions'] as List<Map>)
                .map((Map json) => new Mention.fromJson(json))
            : [],
        issues = json.containsKey('issues')
            ? (json['issues'] as List<Map>)
                .map((Map json) => new Issue.fromJson(json))
            : [],
        v = json['v'];
}
