library gitter.group;

import 'package:jaguar_serializer/serializer.dart';

part 'group.g.dart';

@GenSerializer()
@ProvideSerializer(SecurityDescriptor, SecurityDescriptorSerializer)
class GroupSerializer extends Serializer<Group> with _$GroupSerializer {
  Group createModel() => new Group();
}

@GenSerializer()
class SecurityDescriptorSerializer extends Serializer<SecurityDescriptor>
    with _$SecurityDescriptorSerializer {
  SecurityDescriptor createModel() => new SecurityDescriptor();
}

class Group {
  String id;
  String name;
  String uri;
  SecurityDescriptor backedBy;
  String avatarUrl;

  Group();

  factory Group.fromJson(Map<String, dynamic> json) =>
      new GroupSerializer().fromMap(json);

  @override
  String toString() => "$id $name";
}

class SecurityDescriptor {
  String type;
  String linkPath;

  SecurityDescriptor();

  factory SecurityDescriptor.fromJson(Map<String, dynamic> json) =>
      new SecurityDescriptorSerializer().fromMap(json);
}
