import '../utils.dart';
import 'package:flitter/app.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/routes/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group("$GroupView Widget", () {
    setUpAll(initStores);

    testWidgets("No Rooms", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(scaffold: new GroupView()));

      final scaff = find.byType(Scaffold);

      expect(scaff, findsOneWidget);
      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsOneWidget);
    });

    testWidgets("Fetching Rooms", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(scaffold: new GroupView()));

      final scaff = find.byType(Scaffold);

      fetchRoomsOfGroup();

      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsOneWidget);

      await tester.pump();

      expect(find.descendant(of: scaff, matching: find.byType(LoadingView)),
          findsNothing);
      expect(find.descendant(of: scaff, matching: find.byType(ListView)),
          findsOneWidget);
      expect(find.descendant(of: scaff, matching: find.byType(RoomTile)),
          findsNWidgets(4));
    });
  });
}
