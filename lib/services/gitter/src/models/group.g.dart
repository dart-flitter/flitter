// GENERATED CODE - DO NOT MODIFY BY HAND

part of gitter.group;

// **************************************************************************
// Generator: SerializerGenerator
// Target: class GroupSerializer
// **************************************************************************

abstract class _$GroupSerializer implements Serializer<Group> {
  final SecurityDescriptorSerializer toSecurityDescriptorSerializer =
      new SecurityDescriptorSerializer();
  final SecurityDescriptorSerializer fromSecurityDescriptorSerializer =
      new SecurityDescriptorSerializer();

  Map toMap(Group model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.id != null) {
        ret["id"] = model.id;
      }
      if (model.name != null) {
        ret["name"] = model.name;
      }
      if (model.uri != null) {
        ret["uri"] = model.uri;
      }
      if (model.backedBy != null) {
        ret["backedBy"] = toSecurityDescriptorSerializer.toMap(model.backedBy,
            withType: withType, typeKey: typeKey);
      }
      if (model.avatarUrl != null) {
        ret["avatarUrl"] = model.avatarUrl;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  Group fromMap(Map map, {Group model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! Group) {
      model = createModel();
    }
    model.id = map["id"];
    model.name = map["name"];
    model.uri = map["uri"];
    model.backedBy = fromSecurityDescriptorSerializer.fromMap(map["backedBy"],
        typeKey: typeKey);
    model.avatarUrl = map["avatarUrl"];
    return model;
  }

  String modelString() => "Group";
}

// **************************************************************************
// Generator: SerializerGenerator
// Target: class SecurityDescriptorSerializer
// **************************************************************************

abstract class _$SecurityDescriptorSerializer
    implements Serializer<SecurityDescriptor> {
  Map toMap(SecurityDescriptor model, {bool withType: false, String typeKey}) {
    Map ret = new Map();
    if (model != null) {
      if (model.type != null) {
        ret["type"] = model.type;
      }
      if (model.linkPath != null) {
        ret["linkPath"] = model.linkPath;
      }
      if (modelString() != null && withType) {
        ret[typeKey ?? defaultTypeInfoKey] = modelString();
      }
    }
    return ret;
  }

  SecurityDescriptor fromMap(Map map,
      {SecurityDescriptor model, String typeKey}) {
    if (map is! Map) {
      return null;
    }
    if (model is! SecurityDescriptor) {
      model = createModel();
    }
    model.type = map["type"];
    model.linkPath = map["linkPath"];
    return model;
  }

  String modelString() => "SecurityDescriptor";
}
