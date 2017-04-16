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
    return new User.fromJson(_getResponseBody(response));
  }

  Future<List<Room>> rooms() async {
    final http.Response response =
        await http.get("$_baseUrl/rooms", headers: _getHeaders(token));
    final List<Map> json = _getResponseBody(response);
    List<Room> rooms = json.map((map) => new Room.fromJson(map)).toList();
    // TODO: better sort
    // fixme: should we do that here ?
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

  Future<List<User>> search(String query,
      {int limit: 15, String type: "gitter"}) async {
    final http.Response response = await http.get(
        "$_baseUrl?q=$query&limit=$limit&type=$type",
        headers: _getHeaders(_token));
    final List<Map> json = _getResponseBody(response)["results"];
    return json.map((map) => new User.fromJson(map)).toList();
  }

  Future<List<Room>> channelsOf(String userId) async {
    final http.Response response = await http.get("$_baseUrl/$userId/channels",
        headers: _getHeaders(_token));
    final List<Map> json = _getResponseBody(response);
    return json.map((map) => new Room.fromJson(map)).toList();
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

  Future<List<Room>> search(String query,
      {int limit: 15, String type: "gitter"}) async {
    final http.Response response = await http.get(
        "$_baseUrl?q=$query&limit=$limit&type=$type",
        headers: _getHeaders(token));
    final List<Map> json = _getResponseBody(response)["results"];
    return json.map((map) => new Room.fromJson(map)).toList();
  }

  Future<Null> messagesFromRoomId(String id,
      {int skip: 0, int limit: 50, bool clear: false}) async {
    final http.Response response = await http.get(
        "$_baseUrl/$id/chatMessages?skip=$skip&limit=$limit",
        headers: _getHeaders(token));
    final List<Map> json = _getResponseBody(response);
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
    final Message m = new Message.fromJson(_getResponseBody(response));
    messages.add(m);
    return m;
  }

  Future<Room> roomFromUri(String uri) async {
    uri = Uri.parse(uri).pathSegments.first;
    final Map<String, String> json = {"uri": uri};
    final http.Response response = await http.post(
      "$_baseUrl",
      body: JSON.encode(json),
      headers: _getHeaders(token),
    );
    final room = new Room.fromJson(_getResponseBody(response));
    return room;
  }
}

class GitterApi {
  final String _baseUrl = "https://api.gitter.im/v1";

  GitterToken _token;
  UserApi user;
  RoomApi room;
  GroupApi group;

  GitterApi(this._token) {
    user = new UserApi(_baseUrl, _token);
    room = new RoomApi(_baseUrl, _token);
    group = new GroupApi(_baseUrl, _token);
  }

  void set token(GitterToken value) {
    _token = value;
    user.token = value;
    room.token = value;
  }
}

class GroupApi {
  final String _baseUrl;
  GitterToken token;

  GroupApi(String baseUrl, this.token) : _baseUrl = "$baseUrl/groups";

  Future<List<Group>> get() async {
    final http.Response response =
        await http.get("$_baseUrl/", headers: _getHeaders(token));
    final List<Map> json = _getResponseBody(response);
    return json.map((map) => new Group.fromJson(map)).toList();
  }

  Future<List<Room>> roomsOf(String groupId) async {
    final http.Response response =
        await http.get("$_baseUrl/$groupId/rooms", headers: _getHeaders(token));
    final List<Map> json = _getResponseBody(response);
    return json.map((map) => new Room.fromJson(map)).toList();
  }

  Future<List<Room>> suggestedRoomsOf(String groupId) async {
    final http.Response response = await http
        .get("$_baseUrl/$groupId/suggestedRooms", headers: _getHeaders(token));
    final List<Map> json = _getResponseBody(response);
    return json.map((map) => new Room.fromJson(map)).toList();
  }
}

dynamic _getResponseBody(http.Response response) {
  final body = JSON.decode(response.body);
  if (response != null &&
      response.statusCode >= 200 &&
      response.statusCode < 300) {
    if (body is Map && body.containsKey("error")) {
      if (body['error'] == "Not Found") {
        throw new GitterNotFoundException(body: body, response: response);
      }
      throw new GitterErrorException(body: body, response: response);
    }
    return body;
  }
  throw new GitterHttpStatusException(body: body, response: response);
}

class GitterErrorException implements Exception {
  final http.Response response;
  final dynamic body;
  GitterErrorException({this.body, this.response});
}

class GitterHttpStatusException extends GitterErrorException {
  int get status => response?.statusCode;
  GitterHttpStatusException({body, http.Response response})
      : super(body: body, response: response);
}

class GitterNotFoundException extends GitterErrorException {
  GitterNotFoundException({body, http.Response response})
      : super(body: body, response: response);
}