library flitter.routes;

import 'routes/home/route.dart';
import 'routes/people/route.dart';

export 'routes/home/route.dart';
export 'routes/people/route.dart';

const kRoutes = const {
  Home.path: Home.builder,
  PeoplePage.path: PeoplePage.builder
};
