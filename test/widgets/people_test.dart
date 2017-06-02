import '../utils.dart';
import 'package:flitter/app.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/common/search.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("$PeopleView Widget", () {
    setUpAll(initStores);

    testWidgets("No Rooms", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(scaffold: new PeopleView()));

      final scaff = find.byType(ScaffoldWithSearchbar);

      expect(scaff, findsOneWidget);
      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsOneWidget);
    });

    testWidgets("Fetching Rooms", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(scaffold: new PeopleView()));

      final scaff = find.byType(ScaffoldWithSearchbar);

      fetchRooms();

      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsOneWidget);

      await tester.pump();

      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsNothing);
      expect(find.descendant(of: scaff, matching: find.byType(ListRoom)),
          findsOneWidget);
      expect(find.descendant(of: scaff, matching: find.byType(RoomTile)),
          findsNWidgets(1));
    });

    testWidgets("Pull to Refresh", (WidgetTester tester) async {
      flitterStore =
          new FlitterStore(initialState: flitterStore.state.apply(rooms: []));

      await tester.pumpWidget(
          new MockableApp(scaffold: new PeopleView(onRefresh: () async {
        fetchRooms();
      })));

      final scaff = find.byType(ScaffoldWithSearchbar);
      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsNothing);
      expect(find.descendant(of: scaff, matching: find.byType(ListRoom)),
          findsOneWidget);
      expect(find.descendant(of: scaff, matching: find.byType(RoomTile)),
          findsNothing);

      await tester.flingFrom(
          const Offset(50.0, 300.0), const Offset(0.0, 300.0), 1000.0);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(RoomTile), findsNWidgets(1));
    });
  });
}
