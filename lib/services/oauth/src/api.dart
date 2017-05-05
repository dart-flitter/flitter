library oauth.oauth;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/services/oauth/src/models/app_informations.dart';
import 'package:flitter/services/oauth/src/models/code_informations.dart';
import 'package:flitter/services/oauth/src/models/token_informations.dart';
import 'package:http/http.dart' as http;

abstract class OAuth {
  final AppInformations appInformations;
  final CodeInformations codeInformations;

  String code;
  Map<String, dynamic> token;

  TokenInformations tokenInformations;

  OAuth(this.appInformations, this.codeInformations);

  Future<Map<String, dynamic>> getToken() async {
    if (token == null || tokenInformations.force) {
      http.Response response;
      if (tokenInformations.isPost) {
        response = await http.post("${tokenInformations.url}",
            body: JSON.encode(tokenInformations.params),
            headers: tokenInformations.headers);
      } else {
        response = await http.get("${tokenInformations.url}?${mapToQueryParams(
            tokenInformations.params)}");
      }
      token = JSON.decode(response.body);
    }
    return token;
  }

  bool shouldRequestCode() => code == null || codeInformations.force;

  String constructUrlParams() => mapToQueryParams(codeInformations.params);

  String mapToQueryParams(Map<String, String> params) {
    final List<String> queryParams = [];
    params
        .forEach((String key, String value) => queryParams.add("$key=$value"));
    return queryParams.join("&");
  }

  Future<String> requestCode();
  void generateTokenInformations();
}
