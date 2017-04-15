library gitter.token;

import 'package:flitter/services/oauth/oauth.dart';
import 'package:jaguar_serializer/serializer.dart';

part 'token.g.dart';

@GenSerializer(typeInfo: false)
@EnDecodeField(#access, asAndFrom: "access_token")
@EnDecodeField(#type, asAndFrom: "token_type")
class GitterTokenSerialalizer extends Serializer<GitterToken>
    with _$GitterTokenSerialalizer {
  @override
  GitterToken createModel() => new GitterToken();
}

class GitterToken implements Token {
  static final serializer = new GitterTokenSerialalizer();

  @override
  String access;

  @override
  String type;

  GitterToken();

  factory GitterToken.fromJson(Map<String, String> json) =>
      serializer.fromMap(json);

  Map<String, String> toMap() => serializer.toMap(this);

  @override
  String toString() => toMap().toString();
}
