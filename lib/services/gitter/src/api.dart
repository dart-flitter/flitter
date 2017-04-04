library gitter.api;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/services/gitter/src/models/room.dart';
import 'package:flitter/services/gitter/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flitter/services/gitter/src/token.dart';

Map<String, String> _getHeaders(Token token) {
  return {
    "Accept": "application/json",
    "Authorization": "Bearer ${token.access}"
  };
}

class MeApi {
  final String _baseUrl;
  Token token;

  MeApi(String baseUrl, this.token) : _baseUrl = "$baseUrl/me";

  Future<User> get() async {
    final http.Response response =
        await http.get("$_baseUrl/me", headers: _getHeaders(token));
    return new User.fromJson(JSON.decode(response.body));
  }

  Future<List<Room>> rooms() async {
    final http.Response response =
        await http.get("$_baseUrl/me/rooms", headers: _getHeaders(token));
    final List<Map> json = JSON.decode(response.body);
    return json.map((map) => new Room.fromJson(map)).toList();
  }
}

class UserApi {
  final String _baseUrl;
  Token _token;

  MeApi me;

  UserApi(String baseUrl, this._token) : _baseUrl = "$baseUrl/user/" {
    me = new MeApi(_baseUrl, _token);
  }

  void set token(Token value) {
    _token = value;
    me.token = value;
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
