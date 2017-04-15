// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.room;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class RoomSerialalizer
// **************************************************************************

abstract class _$RoomSerialalizer implements Serializer<Room> {
  final UserSerialalizer toUserSerialalizer = new UserSerialalizer();
  final UserSerialalizer fromUserSerialalizer = new UserSerialalizer();

  Map toMap(Room model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.topic != null) {
        ret["topic"] = model.topic;
      }
      if (model.uri != null) {
        ret["uri"] = model.uri;
      }
      if (model.oneToOne != null) {
        ret["oneToOne"] = model.oneToOne;
      }
      if (model.userCount != null) {
        ret["userCount"] = model.userCount;
      }
      if (model.user != null) {
        ret["user"] = toUserSerialalizer.toMap(model.user,
            withType: withType, typeKey: typeKey);
      }
      if (model.unreadItems != null) {
        ret["unreadItems"] = model.unreadItems;
      }
      if (model.mentions != null) {
        ret["mentions"] = model.mentions;
      }
      if (model.lastAccessTime != null) {
        ret["lastAccessTime"] = model.lastAccessTime;
      }
      if (model.lurk != null) {
        ret["lurk"] = model.lurk;
      }
      if (model.url != null) {
        ret["url"] = model.url;
      }
      if (model.githubType != null) {
        ret["githubType"] = model.githubType;
      }
      if (model.tags != null) {
        ret["tags"] =
            model.tags?.map((String val) => val != null ? val : null)?.toList();
      }
      if (model.v != null) {
        ret["v"] = model.v;
      }
      if (model.avatarUrl != null) {
        ret["avatarUrl"] = model.avatarUrl;
      }
    }
    return ret;
  }

  Room fromMap(Map map, {Room model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Room) {
      model = createModel();
    }
    model.id = map["id"];
    model.name = map["name"];
    model.topic = map["topic"];
    model.uri = map["uri"];
    model.oneToOne = map["oneToOne"];
    model.userCount = map["userCount"];
    model.user = fromUserSerialalizer.fromMap(map["user"], typeKey: typeKey);
    model.unreadItems = map["unreadItems"];
    model.mentions = map["mentions"];
    model.lastAccessTime = map["lastAccessTime"];
    model.lurk = map["lurk"];
    model.url = map["url"];
    model.githubType = map["githubType"];
    model.tags = map["tags"]?.map((String val) => val)?.toList();
    model.v = map["v"];
    model.avatarUrl = map["avatarUrl"];
    return model;
  }

  String modelString() => "Room";
}
