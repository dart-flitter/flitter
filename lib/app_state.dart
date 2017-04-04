library flitter.app_state;

import 'package:flitter/services/gitter/gitter.dart';
import 'package:flitter/services/gitter/src/models/room.dart';

class AppState {
  Token token;
  GitterApi gApi;
  User user;
  List<Room> rooms;

  static AppState _instance;
  AppState._internal();

  factory AppState() {
    if (_instance == null) {
      _instance = new AppState._internal();
    }
    return _instance;
  }
}