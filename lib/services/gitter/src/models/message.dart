library gitter.message;

import 'package:flitter/services/gitter/src/models/issue.dart';
import 'package:flitter/services/gitter/src/models/mention.dart';
import 'package:flitter/services/gitter/src/models/user.dart';
import 'package:jaguar_serializer/serializer.dart';

part 'message.g.dart';

@GenSerializer(typeInfo: false)
@ProvideSerializer(Mention, MentionSerializer)
@ProvideSerializer(Issue, IssueSerializer)
@ProvideSerializer(User, UserSerialalizer)
class MessageSerializer extends Serializer<Message> with _$MessageSerializer {
  @override
  Message createModel() => new Message();
}

class Message {
  String id;
  String text;
  String html;
  String sent;
  String editedAt;
  User fromUser;
  bool unread;
  int readBy;
  List<String> urls;
  List<Mention> mentions;
  List<Issue> issues;
//  not used right now
//  final meta;
  int v;
//  final gv;

  Message();

  factory Message.fromJson(Map<String, dynamic> json) =>
      new MessageSerializer().fromMap(json);

  @override
  String toString() => "$id ${fromUser.displayName}";
}
