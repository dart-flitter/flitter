library gitter.group;

class Group {
  final String id;
  final String name;
  final String uri;
  final SecurityDescriptor backedBy;
  final String avatarUrl;

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        uri = json['uri'],
        backedBy = json.containsKey('backedBy')
            ? new SecurityDescriptor.fromJson(json['backedBy'])
            : null,
        avatarUrl = json['avatarUrl'];

  @override
  String toString() => "$id $name";
}

class SecurityDescriptor {
  final String type;
  final String linkPath;

  SecurityDescriptor.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        linkPath = json['linkPath'];
}
