import 'package:flitter/app.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flitter/redux/store.dart';

main() {
  group("$Splash Widget", () {
    testWidgets("Inside Scaffold", (WidgetTester tester) async {
      await tester.pumpWidget(new Splash());

      // MaterialApp exist
      final appFinder = find.byType(MaterialApp);
      expect(appFinder, findsOneWidget);

      // Scaffold exist
      final scaffoldFinder =
          find.descendant(of: appFinder, matching: find.byType(Scaffold));
      expect(scaffoldFinder, findsOneWidget);

      // Text is correct
      final titleFinder =
          find.descendant(of: scaffoldFinder, matching: find.byType(Text));
      expect(titleFinder, findsNWidgets(2));
      final title = tester.firstWidget(titleFinder) as Text;
      expect(title.data, equals(appName));
    });

    testWidgets("Default Color", (WidgetTester tester) async {
      await tester.pumpWidget(new Splash());

      final logoFinder = find.byType(FlutterLogo);
      expect(logoFinder, findsOneWidget);
      final logo = tester.firstWidget(logoFinder) as FlutterLogo;
      expect(logo.colors, equals(Colors.pink));
    });
  });
}
