library gitter.api;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/gitter/src/models/message.dart';
import 'package:flitter/services/gitter/src/models/room.dart';
import 'package:flitter/services/gitter/src/models/user.dart';
import 'package:http/http.dart' as http;

Map<String, String> _getHeaders(GitterToken token) {
  return {
    "Accept": "application/json",
    "Authorization": "Bearer ${token.access}"
  };
}

class MeApi {
  final String _baseUrl;
  GitterToken token;

  MeApi(String baseUrl, this.token) : _baseUrl = "$baseUrl/me";

  Future<User> get() async {
    final http.Response response =
        await http.get("$_baseUrl/", headers: _getHeaders(token));
    return new User.fromJson(JSON.decode(response.body));
  }

  Future<List<Room>> rooms() async {
    final http.Response response =
        await http.get("$_baseUrl/rooms", headers: _getHeaders(token));
    final List<Map> json = JSON.decode(response.body);
    return json.map((map) => new Room.fromJson(map)).toList();
  }
}

class UserApi {
  final String _baseUrl;
  GitterToken _token;

  MeApi me;

  UserApi(String baseUrl, this._token) : _baseUrl = "$baseUrl/user" {
    me = new MeApi(_baseUrl, _token);
  }

  void set token(GitterToken value) {
    _token = value;
    me.token = value;
  }
}

class RoomApi {
  final String _baseUrl;
  GitterToken token;

  RoomApi(String baseUrl, this.token) : _baseUrl = "$baseUrl/rooms";

  Future<List<Message>> messagesFromRoomId(String id,
      {int skip: 0, int limit: 50}) async {
    final http.Response response = await http.get(
        "$_baseUrl/$id/chatMessages?skip=$skip&limit=$limit",
        headers: _getHeaders(token));
    final List<Map> json = JSON.decode(response.body);
    return json.map((Map message) => new Message.fromJson(message));
  }
}

class GitterApi {
  final String _baseUrl = "https://api.gitter.im/v1";

  GitterToken _token;
  UserApi user;
  RoomApi room;

  GitterApi(this._token) {
    user = new UserApi(_baseUrl, _token);
    room = new RoomApi(_baseUrl, _token);
  }

  void set token(GitterToken value) {
    _token = value;
    user.token = value;
    room.token = value;
  }
}
