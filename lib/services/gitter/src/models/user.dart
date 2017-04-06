library gitter.user;

class User {
  final String id;
  final String username;
  final String displayName;
  final String url;
  final String avatarUrlSmall;
  final String avatarUrlMedium;
  final bool staff;
  final List<String> providers;
  final num v;
  final String gv;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        displayName = json['displayName'],
        url = json['url'],
        avatarUrlMedium = json['avatarUrlMedium'],
        avatarUrlSmall = json['avatarUrlSmall'],
        staff = json['staff'],
        providers = json['providers'],
        v = json['v'],
        gv = json['gv'];

  @override
  String toString() => "$id $username";
}
