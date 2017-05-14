// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.message;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class MessageSerializer
// **************************************************************************

abstract class _$MessageSerializer implements Serializer<Message> {
  final UserSerialalizer toUserSerialalizer = new UserSerialalizer();
  final MentionSerializer toMentionSerializer = new MentionSerializer();
  final IssueSerializer toIssueSerializer = new IssueSerializer();
  final UserSerialalizer fromUserSerialalizer = new UserSerialalizer();
  final MentionSerializer fromMentionSerializer = new MentionSerializer();
  final IssueSerializer fromIssueSerializer = new IssueSerializer();

  Map toMap(Message model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.text != null) {
        ret["text"] = model.text;
      }
      if (model.html != null) {
        ret["html"] = model.html;
      }
      if (model.sent != null) {
        ret["sent"] = new DateTimeProcessor(#sent).serialize(model.sent);
      }
      if (model.editedAt != null) {
        ret["editedAt"] =
            new DateTimeProcessor(#editedAt).serialize(model.editedAt);
      }
      if (model.fromUser != null) {
        ret["fromUser"] = toUserSerialalizer.toMap(model.fromUser,
            withType: withType, typeKey: typeKey);
      }
      if (model.unread != null) {
        ret["unread"] = model.unread;
      }
      if (model.readBy != null) {
        ret["readBy"] = model.readBy;
      }
      if (model.urls != null) {
        ret["urls"] = model.urls
            ?.map((Map<String, String> val) => val != null
                ? new MapMaker(val, (String key) => key, (String value) {
                    return value;
                  }).model
                : null)
            ?.toList();
      }
      if (model.mentions != null) {
        ret["mentions"] = model.mentions
            ?.map((Mention val) => val != null
                ? toMentionSerializer.toMap(val,
                    withType: withType, typeKey: typeKey)
                : null)
            ?.toList();
      }
      if (model.issues != null) {
        ret["issues"] = model.issues
            ?.map((Issue val) => val != null
                ? toIssueSerializer.toMap(val,
                    withType: withType, typeKey: typeKey)
                : null)
            ?.toList();
      }
      if (model.v != null) {
        ret["v"] = model.v;
      }
    }
    return ret;
  }

  Message fromMap(Map map, {Message model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Message) {
      model = createModel();
    }
    model.id = map["id"];
    model.text = map["text"];
    model.html = map["html"];
    model.sent = new DateTimeProcessor(#sent).deserialize(map["sent"]);
    model.editedAt =
        new DateTimeProcessor(#editedAt).deserialize(map["editedAt"]);
    model.fromUser =
        fromUserSerialalizer.fromMap(map["fromUser"], typeKey: typeKey);
    model.unread = map["unread"];
    model.readBy = map["readBy"];
    model.urls = map["urls"]
        ?.map((Map<String, String> val) =>
            new MapMaker(val, (String key) => key, (String value) {
              return value;
            }).model as dynamic)
        ?.toList();
    model.mentions = map["mentions"]
        ?.map((Map val) => fromMentionSerializer.fromMap(val, typeKey: typeKey))
        ?.toList();
    model.issues = map["issues"]
        ?.map((Map val) => fromIssueSerializer.fromMap(val, typeKey: typeKey))
        ?.toList();
    model.v = map["v"];
    return model;
  }

  String modelString() => "Message";
}
