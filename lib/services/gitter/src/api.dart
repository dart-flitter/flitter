library gitter.api;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/services/gitter/src/user.dart';
import 'package:http/http.dart' as http;
import 'package:flitter/services/gitter/src/token.dart';

Map<String, String> _getHeaders(Token token) {
  return {
    "Accept": "application/json",
    "Authorization": "Bearer ${token.access}"
  };
}

class UserApi {
  final String _baseUrl;

  Token token;

  UserApi(String baseUrl, this.token) : _baseUrl = "$baseUrl/user/";

  Future<User> getMe() async {
    http.Response response = await http.get("$_baseUrl/me", headers: _getHeaders(token));
    return new User.fromJson(JSON.decode(response.body));
  }
}

class GitterApi {
  final String _baseUrl = "https://api.gitter.im/v1/";

  Token _token;
  UserApi user;

  GitterApi(this._token) {
    user = new UserApi(_baseUrl, _token);
  }

  void set token(Token value) {
    _token = value;
    user.token = value;
  }
}
