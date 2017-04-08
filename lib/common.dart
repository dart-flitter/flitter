library flitter.widgets;

import 'package:flitter/services/gitter/gitter.dart';


DateTime parseLastAccessTime(String lastAccessTime) {
  RegExp regExp = new RegExp(
      r"^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})");
  Match match = regExp.firstMatch(lastAccessTime);
  return new DateTime(
    int.parse(match.group(1)),
    int.parse(match.group(2)),
    int.parse(match.group(3)),
    int.parse(match.group(4)),
    int.parse(match.group(5)),
    int.parse(match.group(6)),
  );
}

//  TODO: improve the sort to have better performance
//  use only one sort
void sortRooms(List<Room> rooms) {
  rooms.sort((Room prev, Room next) =>
      parseLastAccessTime(next.lastAccessTime)
          .compareTo(parseLastAccessTime(prev.lastAccessTime)));
  rooms.sort((Room prev, Room next) =>
      next.unreadItems.compareTo(prev.unreadItems));

}