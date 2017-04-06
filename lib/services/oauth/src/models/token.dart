library oauth.token;

abstract class Token {
  String access;
  String type;

  Token.fromJson(Map<String, String> json)
      : access = json['access_token'],
        type = json['token_type'];
}
