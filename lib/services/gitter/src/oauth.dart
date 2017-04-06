library gitter.oauth;

import 'dart:async';

import 'package:flitter/services/gitter/src/models/code_informations.dart';
import 'package:flitter/services/gitter/src/models/token.dart';
import 'package:flitter/services/gitter/src/models/token_informations.dart';
import 'package:flitter/services/oauth/oauth.dart';

class GitterOAuth extends OAuth {
  GitterOAuth(AppInformations appInformations, {bool force: false})
      : super(appInformations, new GitterCodeInformations(appInformations));

  @override
  void generateTokenInformations() {
    tokenInformations = new GitterTokenInformations(appInformations, code);
  }

  Future<GitterToken> signIn() async {
    await getCode();
    generateTokenInformations();
    return new GitterToken.fromJson(await getToken());
  }
}
