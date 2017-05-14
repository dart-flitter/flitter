// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.token;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class GitterTokenSerialalizer
// **************************************************************************

abstract class _$GitterTokenSerialalizer implements Serializer<GitterToken> {
  Map toMap(GitterToken model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.access != null) {
        ret["access_token"] = model.access;
      }
      if (model.type != null) {
        ret["token_type"] = model.type;
      }
    }
    return ret;
  }

  GitterToken fromMap(Map map, {GitterToken model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! GitterToken) {
      model = createModel();
    }
    model.access = map["access_token"];
    model.type = map["token_type"];
    return model;
  }

  String modelString() => "GitterToken";
}
