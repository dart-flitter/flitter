library flitter.routes.settings;

import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/widgets/common/list_room.dart';
import 'package:flitter/widgets/common/search.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:gitter/gitter.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/utils.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
import 'package:flitter/app.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  static const String path = "/settings";

  static void go(BuildContext context, {bool replace: true}) {
    fetchRooms();
    materialNavigateTo(context, new SettingsView(),
        path: SettingsView.path, replace: replace);
  }

  @override
  _SettingsViewState createState() => new _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  var _themeSubscription;

  @override
  void initState() {
    super.initState();
    _themeSubscription = themeStore.onChange.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _themeSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final drawer = new FlitterDrawer(onTapAllConversation: () {
      HomeView.go(context);
    }, onTapPeoples: () {
      PeopleView.go(context);
    }, onTapSettings: () {
      Navigator.pop(context);
    });

    return new Scaffold(
        body: new ListView(children: <Widget>[
          _buildDarkModeSwitch(),
          _buildPrimaryColor(),
          _buildAccentColor(),
          new Divider()
        ]),
        appBar: new AppBar(title: new Text(intl.settings())), drawer: drawer);
  }

  Widget _buildDarkModeSwitch() {
    final brightness = themeStore.state.theme.brightness != Brightness.light;

    return new ListTile(
        title: new Row(children: [
          new Expanded(child: new Text(intl.darkMode())),
          new Switch(value: brightness,
              onChanged: (bool value) async {
                if (value != brightness) {
                  themeStore.dispatch(new ChangeThemeAction(
                      brightness: value == true
                          ? Brightness.dark
                          : Brightness
                          .light));
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  prefs.setBool(
                      ThemeState.kBrightnessKey, value);
                  await prefs.commit();
                }
              })
        ]));
  }

  Widget _buildPrimaryColor() {
    return _buildColorTile(
        intl.primaryColor(), themeStore.state.primaryColor, () {
      showDialog(context: context,
        child: new SimpleDialog(title: new Text(intl.primaryColor()),
          titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
          contentPadding: EdgeInsets.zero,
          children: <Widget>[
            new MaterialPrimaryColorGrid(
                onTap: (ColorSwatch color) async {
                  themeStore.dispatch(
                      new ChangeThemeAction(primaryColor: color));
                  Navigator.pop(context);
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  prefs.setInt(
                      ThemeState.kPrimaryColorKey,
                      Colors.primaries.indexOf(color));
                  await prefs.commit();
                })
          ],
        ),
      );
    });
  }

  Widget _buildAccentColor() {
    return _buildColorTile(
        intl.accentColor(), themeStore.state.accentColor, () {
      showDialog(context: context,
        child: new SimpleDialog(title: new Text(intl.accentColor()),
          titlePadding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
          contentPadding: EdgeInsets.zero,
          children: <Widget>[
            new MaterialAccentColorGrid(
                onTap: (ColorSwatch color) async {
                  themeStore.dispatch(
                      new ChangeThemeAction(accentColor: color));
                  Navigator.pop(context);
                  SharedPreferences prefs = await SharedPreferences
                      .getInstance();
                  prefs.setInt(
                      ThemeState.kAccentColorKey,
                      Colors.accents.indexOf(color));
                  await prefs.commit();
                })
          ],
        ),
      );
    });
  }

  Widget _buildColorTile(String text, ColorSwatch color, VoidCallback onTap) {
    return new ListTile(
        title: new Row(children: [
          new Expanded(child: new Text(text)),
          new Padding(padding: new EdgeInsets.only(right: 14.0),
              child: new ColorTile(color: color,
                  size: 40.0,
                  rounded: true)),
        ]), onTap: onTap);
  }
}

class ColorTile extends StatelessWidget {

  final ColorSwatch color;
  final VoidCallback onTap;
  final bool rounded;
  final double size;

  ColorTile(
      {@required this.color, this.onTap, this.size = 70.0, this.rounded = false});

  @override
  Widget build(BuildContext context) {
    var body;
    if (rounded) {
      body =
      new Container(
          height: size,
          width: size,
          decoration: new BoxDecoration(
              color: color,
              shape: BoxShape.circle));
    } else {
      body = new Container(
          height: size,
          width: size,
          color: color);
    }

    return new GestureDetector(onTap: onTap, child: body);
  }
}

class MaterialPrimaryColorGrid extends StatelessWidget {

  final ValueChanged<ColorSwatch> onTap;
  final bool rounded;

  MaterialPrimaryColorGrid({@required this.onTap, this.rounded = false});

  @override
  Widget build(BuildContext context) {
    final colors = _buildColorRows(Colors.primaries, onTap, rounded: rounded);

    return new Column(children: colors);
  }
}

class MaterialAccentColorGrid extends StatelessWidget {

  final ValueChanged<ColorSwatch> onTap;
  final bool rounded;

  MaterialAccentColorGrid({@required this.onTap, this.rounded = false});

  @override
  Widget build(BuildContext context) {
    final colors = _buildColorRows(Colors.accents, onTap, rounded: rounded);

    return new Column(children: colors);
  }
}

_buildColorRows(List<ColorSwatch> colors, ValueChanged<ColorSwatch> onTap,
    {int sizeRow: 4, bool rounded = false}) {
  final rows = [];
  int count = 0;
  var row;
  for (ColorSwatch color in colors) {
    if (count % sizeRow == 0) {
      if (row != null) {
        rows.add(new Row(
            children: row, mainAxisAlignment: MainAxisAlignment.center));
      }
      row = [];
    }
    row.add(new ColorTile(color: color, onTap: () {
      onTap(color);
    }, rounded: rounded));
    count++;
  }

  if (row?.isNotEmpty == true) {
    rows.add(new Row(children: row,
        mainAxisAlignment: row.length == sizeRow
            ? MainAxisAlignment.center
            : MainAxisAlignment.start));
  }
  return rows;
}
