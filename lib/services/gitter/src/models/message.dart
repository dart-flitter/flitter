library gitter.message;

import 'package:flitter/services/gitter/src/models/issue.dart';
import 'package:flitter/services/gitter/src/models/mention.dart';
import 'package:flitter/services/gitter/src/models/user.dart';
import 'package:jaguar_serializer/serializer.dart';

part 'message.g.dart';

@DefineFieldProcessor()
class DateTimeProcessor implements FieldProcessor<DateTime, String> {
  final Symbol field;
  const DateTimeProcessor(this.field);

  @override
  String serialize(DateTime value) => value?.toIso8601String();

  @override
  DateTime deserialize(String value) =>
      value != null ? DateTime.parse(value) : null;
}

@GenSerializer(typeInfo: false)
@ProvideSerializer(Mention, MentionSerializer)
@ProvideSerializer(Issue, IssueSerializer)
@ProvideSerializer(User, UserSerialalizer)
@DateTimeProcessor(#sent)
@DateTimeProcessor(#editedAt)
class MessageSerializer extends Serializer<Message> with _$MessageSerializer {
  @override
  Message createModel() => new Message();
}

class Message {
  static final serializer = new MessageSerializer();
  String id;
  String text;
  String html;
  DateTime sent;
  DateTime editedAt;
  User fromUser;
  bool unread;
  int readBy;
  List<Map<String, String>> urls;
  List<Mention> mentions;
  List<Issue> issues;
//  not used right now
//  final meta;
  int v;
//  final gv;

  Message();

  factory Message.fromJson(Map<String, dynamic> json) =>
      serializer.fromMap(json);

  @override
  String toString() => serializer.toMap(this).toString();
}
