library flitter.routes;

import 'widgets/routes/home.dart';
import 'widgets/routes/people.dart';
import 'widgets/routes/room.dart';

export 'widgets/routes/home.dart';
export 'widgets/routes/people.dart';
export 'widgets/routes/room.dart';

const kRoutes = const {
  HomeView.path: HomeView.builder,
  PeopleView.path: PeopleView.builder,
  RoomView.path: RoomView.builder
};
