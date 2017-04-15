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
  @override
  String access;

  @override
  String type;

  GitterToken();

  factory GitterToken.fromJson(Map<String, String> json) =>
      new GitterTokenSerialalizer().fromMap(json);

  Map<String, String> toMap() => new GitterTokenSerialalizer().toMap(this);
}
