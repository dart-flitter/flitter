library gitter.get_token;

import 'dart:async';

import 'package:flitter/services/oauth/oauth.dart' as oauth;
import 'package:flitter/services/gitter/src/models/token.dart';

Future<String> getCode(String appId, String redirectUri) async {
  final Map<String, String> params = {
    "client_id": appId,
    "response_type": "code",
    "redirect_uri": redirectUri,
  };
  return await oauth.getCode("https://gitter.im/login/oauth/authorize", params);
}

Future<Token> getToken(
    String code, String appId, String appSecret, String redirectUri) async {
  final Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };
  final Map<String, String> params = {
    "client_id": appId,
    "client_secret": appSecret,
    "code": code,
    "redirect_uri": redirectUri,
    "grant_type": "authorization_code",
  };
  Map<String, String> json = await oauth.getToken(
      "https://gitter.im/login/oauth/token", code, params,
      isPost: true, headers: headers);
  return new Token.fromJson(json);
}
