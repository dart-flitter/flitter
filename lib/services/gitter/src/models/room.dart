library gitter.room;

import 'package:flitter/services/gitter/src/models/user.dart';
import 'package:jaguar_serializer/serializer.dart';

part 'room.g.dart';

@GenSerializer(typeInfo: false)
@ProvideSerializer(User, UserSerialalizer)
class RoomSerialalizer extends Serializer<Room> with _$RoomSerialalizer {
  @override
  Room createModel() => new Room();
}

class Room {
  static final serializer = new RoomSerialalizer();
  String id;
  String name;
  String topic;
  String uri;
  bool oneToOne;
  num userCount;
  User user;
  num unreadItems = 0;
  num mentions = 0;
  String lastAccessTime;
  bool lurk;
  String url;
  String githubType;
  List<String> tags;
  num v;
  String avatarUrl;

  Room();

  factory Room.fromJson(Map<String, dynamic> json) => serializer.fromMap(json);

  @override
  String toString() => serializer.toMap(this).toString();
}
