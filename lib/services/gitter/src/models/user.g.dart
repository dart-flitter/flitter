// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.user;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class UserSerialalizer
// **************************************************************************

abstract class _$UserSerialalizer implements Serializer<User> {
  Map toMap(User model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.username != null) {
        ret["username"] = model.username;
      }
      if (model.displayName != null) {
        ret["displayName"] = model.displayName;
      }
      if (model.url != null) {
        ret["url"] = model.url;
      }
      if (model.avatarUrlSmall != null) {
        ret["avatarUrlSmall"] = model.avatarUrlSmall;
      }
      if (model.avatarUrlMedium != null) {
        ret["avatarUrlMedium"] = model.avatarUrlMedium;
      }
      if (model.staff != null) {
        ret["staff"] = model.staff;
      }
      if (model.providers != null) {
        ret["providers"] = model.providers
            ?.map((String val) => val != null ? val : null)
            ?.toList();
      }
      if (model.v != null) {
        ret["v"] = model.v;
      }
      if (model.gv != null) {
        ret["gv"] = model.gv;
      }
    }
    return ret;
  }

  User fromMap(Map map, {User model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! User) {
      model = createModel();
    }
    model.id = map["id"];
    model.username = map["username"];
    model.displayName = map["displayName"];
    model.url = map["url"];
    model.avatarUrlSmall = map["avatarUrlSmall"];
    model.avatarUrlMedium = map["avatarUrlMedium"];
    model.staff = map["staff"];
    model.providers = map["providers"]?.map((String val) => val)?.toList();
    model.v = map["v"];
    model.gv = map["gv"];
    return model;
  }

  String modelString() => "User";
}
