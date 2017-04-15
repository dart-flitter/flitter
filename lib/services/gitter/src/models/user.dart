library gitter.user;

import 'package:jaguar_serializer/serializer.dart';

part 'user.g.dart';

@GenSerializer(typeInfo: false)
class UserSerialalizer extends Serializer<User> with _$UserSerialalizer {
  @override
  User createModel() => new User();
}

class User {
  String id;
  String username;
  String displayName;
  String url;
  String avatarUrlSmall;
  String avatarUrlMedium;
  bool staff;
  List<String> providers;
  num v;
  String gv;

  User();

  factory User.fromJson(Map<String, dynamic> json) =>
      new UserSerialalizer().fromMap(json);

  @override
  String toString() => "$id $username";
}
