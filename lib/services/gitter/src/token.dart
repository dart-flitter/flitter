library gitter.token;

class Token {
  final String access;
  final String type;

  Token(this.access, this.type);

  Token.fromJson(Map<String, String> json)
      : access = json['access_token'],
        type = json['token_type'];

  @override
  String toString() => "$access $type";
}
