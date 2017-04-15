// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.issue;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class IssueSerializer
// **************************************************************************

abstract class _$IssueSerializer implements Serializer<Issue> {
  Map toMap(Issue model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.number != null) {
        ret["number"] = model.number;
      }
    }
    return ret;
  }

  Issue fromMap(Map map, {Issue model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Issue) {
      model = createModel();
    }
    model.number = map["number"];
    return model;
  }

  String modelString() => "Issue";
}
