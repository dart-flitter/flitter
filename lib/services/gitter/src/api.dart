library gitter.api;

import 'dart:async';
import 'dart:convert';

import 'package:flitter/common.dart';
import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/gitter/src/models/message.dart';
import 'package:flitter/services/gitter/src/models/room.dart';
import 'package:flitter/services/gitter/src/models/user.dart';
import 'package:http/http.dart' as http;

Map<String, String> _getHeaders(GitterToken token) {
  return {
    "Accept": "application/json",
    "Content-Type": "application/json",
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
    List<Room> rooms = json.map((map) => new Room.fromJson(map)).toList();
    // TODO: better sort
    rooms
      ..removeWhere((Room room) => room.lastAccessTime == null)
      ..sort((Room prev, Room next) => parseLastAccessTime(next.lastAccessTime)
          .compareTo(parseLastAccessTime(prev.lastAccessTime)))
      ..sort((Room prev, Room next) =>
          next.unreadItems.compareTo(prev.unreadItems));
    return rooms;
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

  List<Message> messages;

  StreamController<Message> _onMessage;

  RoomApi(String baseUrl, this.token) : _baseUrl = "$baseUrl/rooms" {
    messages = [];
    _onMessage = new StreamController.broadcast();
  }

  Stream<Message> get onMessage => _onMessage.stream;

  Future<Null> messagesFromRoomId(String id,
      {int skip: 0, int limit: 50, bool clear: false}) async {
    final http.Response response = await http.get(
        "$_baseUrl/$id/chatMessages?skip=$skip&limit=$limit",
        headers: _getHeaders(token));
    final List<Map> json = JSON.decode(response.body);
    List<Message> m = json
        .map<Message>((Map message) => new Message.fromJson(message))
        .toList();
    _onMessage.addStream(new Stream.fromIterable(m));
  }

  Future<Message> sendMessageToRoomId(String id, String message) async {
    final Map<String, String> json = {"text": message};
    final http.Response response = await http.post(
      "$_baseUrl/$id/chatMessages",
      body: JSON.encode(json),
      headers: _getHeaders(token),
    );
    final Message m = new Message.fromJson(JSON.decode(response.body));
    messages.add(m);
    return m;
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
