// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.mentions;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class MentionSerializer
// **************************************************************************

abstract class _$MentionSerializer implements Serializer<Mention> {
  Map toMap(Mention model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.screenName != null) {
        ret["screenName"] = model.screenName;
      }
      if (model.userId != null) {
        ret["userId"] = model.userId;
      }
    }
    return ret;
  }

  Mention fromMap(Map map, {Mention model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Mention) {
      model = createModel();
    }
    model.screenName = map["screenName"];
    model.userId = map["userId"];
    return model;
  }

  String modelString() => "Mention";
}
