library gitter.token;

import 'package:flitter/services/oauth/oauth.dart';

class GitterToken implements Token {
  @override
  String access;

  @override
  String type;

  GitterToken.fromJson(Map<String, String> json)
      : access = json['access_token'],
        type = json['token_type'];

  Map<String, String> toMap() => {"access_token": access, "token_type": type};
}
