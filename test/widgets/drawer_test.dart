import '../utils.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/intl/messages_all.dart' as intl;

main() {
  group("$FlitterDrawer Widget", () {
    setUpAll(initStores);

    testWidgets("No user", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(
          drawer: new FlitterDrawer(
              onTapAllConversation: () {},
              onTapPeoples: () {},
              onTapSettings: () {})));

      // open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();

      await tester.pump();

      // drawer with a Loader
      final progressFinder = find.byType(CircularProgressIndicator);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets("fetch user", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(
          drawer: new FlitterDrawer(
              onTapAllConversation: () {},
              onTapPeoples: () {},
              onTapSettings: () {})));

      // open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();

      fetchUser();

      await tester.pump();

      // drawer with user
      final drawerFinder = find.byType(FlitterDrawerContent);
      expect(drawerFinder, findsOneWidget);
    });

    testWidgets("Header", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(
          drawer: new FlitterDrawer(
              onTapAllConversation: () {},
              onTapPeoples: () {},
              onTapSettings: () {})));

      // open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();

      fetchUser();

      await tester.pump();

      // drawer with header
      final userAccountHeaderFinder = find.byType(UserAccountsDrawerHeader);
      expect(userAccountHeaderFinder, findsOneWidget);
      final userAccountHeader = tester.firstWidget(userAccountHeaderFinder)
          as UserAccountsDrawerHeader;
      expect((userAccountHeader.accountName as Text).data,
          equals(flitterStore.state.user.username));
      expect((userAccountHeader.accountEmail as Text).data,
          equals(flitterStore.state.user.displayName));
    });

    testWidgets("Footer", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(
          drawer: new FlitterDrawer(
              onTapAllConversation: () {},
              onTapPeoples: () {},
              onTapSettings: () {})));

      // open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();

      fetchUser();

      await tester.pump();

      // drawer with footer
      final drawerFooterFinder = find.byType(FlitterDrawerFooter);
      expect(drawerFooterFinder, findsOneWidget);

      final logoutButtonFinder = find.descendant(
          of: drawerFooterFinder, matching: find.byType(ListTile));
      expect(logoutButtonFinder, findsOneWidget);

      final logoutButton = tester.firstWidget(logoutButtonFinder) as ListTile;
      expect((logoutButton.leading as Icon).icon, equals(Icons.exit_to_app));
      expect((logoutButton.title as Text).data, equals(intl.logout()));
      expect(logoutButton.onTap, isNotNull);
    });

    testWidgets("Communities", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(
          drawer: new FlitterDrawer(
              onTapAllConversation: () {},
              onTapPeoples: () {},
              onTapSettings: () {})));

      // open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();

      fetchUser();

      await tester.pump();

      final drawerCommunitiesFinder = find.byType(FlitterDrawerCommunityTile);

      // drawer without Communities
      expect(drawerCommunitiesFinder, findsNothing);

      fetchCommunities();

      await tester.pump();

      // drawer with Communities footer
      expect(drawerCommunitiesFinder, findsNWidgets(2));

      final tiles = tester.widgetList(drawerCommunitiesFinder)
          as Iterable<FlitterDrawerCommunityTile>;
      for (var tile in tiles) {
        expect(flitterStore.state.groups, contains(tile.group));
      }
    });

    testWidgets("Tap logout", (WidgetTester tester) async {
      await tester.pumpWidget(new MockableApp(
          drawer: new FlitterDrawer(
              onTapAllConversation: () {},
              onTapPeoples: () {},
              onTapSettings: () {})));

      // open drawer
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();

      fetchUser();

      await tester.pump();

      // drawer with footer
      final drawerFooterFinder = find.byType(FlitterDrawerFooter);
      final logoutButtonFinder = find.descendant(
          of: drawerFooterFinder, matching: find.byType(ListTile));

      expect(logoutButtonFinder, findsOneWidget);

      //await tester.tap(logoutButtonFinder);
      final logoutButton = tester.firstWidget(logoutButtonFinder) as ListTile;
      logoutButton.onTap();

      await tester.pump();
    });
  });
}
