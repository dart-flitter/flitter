library gitter.token;

class Token {
  final String access;
  final String type;

  Token(this.access, this.type);

  Token.fromJson(Map<String, String> json)
      : access = json['access_token'],
        type = json['token_type'];

  Map<String, String> toMap() => {"access_token": access, "token_type": type};

  @override
  String toString() => "$access $type";
}
