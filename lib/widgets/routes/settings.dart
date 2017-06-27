library flitter.routes.settings;

import 'package:flutter_color_picker/flutter_color_picker.dart';
import 'package:flitter/redux/actions.dart';
import 'package:flitter/redux/flitter_app_state.dart';
import 'package:flitter/widgets/routes/people.dart';
import 'package:flutter/material.dart';
import 'package:flitter/redux/store.dart';
import 'package:flitter/services/flitter_request.dart';
import 'package:flitter/widgets/common/drawer.dart';
import 'package:flitter/widgets/common/utils.dart';
import 'package:flitter/widgets/routes/home.dart';
import 'package:flitter/intl/messages_all.dart' as intl;
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
        appBar: new AppBar(title: new Text(intl.settings())),
        drawer: drawer);
  }

  Widget _buildDarkModeSwitch() {
    final brightness = themeStore.state.theme.brightness != Brightness.light;

    return new ListTile(
        title: new Row(children: [
      new Expanded(child: new Text(intl.darkMode())),
      new Switch(
          value: brightness,
          onChanged: (bool value) async {
            if (value != brightness) {
              themeStore.dispatch(new ChangeThemeAction(
                  brightness:
                      value == true ? Brightness.dark : Brightness.light));
              persistBrightness(value);
            }
          })
    ]));
  }

  Widget _buildPrimaryColor() {
    return _buildColorTile(intl.primaryColor(), themeStore.state.primaryColor,
        () async {
      Color color = await showDialog(
          context: context,
          child: new PrimaryColorPickerDialog(
              selected: themeStore.state.primaryColor));
      if (color != null) {
        themeStore.dispatch(new ChangeThemeAction(primaryColor: color));
        persistAccentColor(color);
      }
    });
  }

  Widget _buildAccentColor() {
    return _buildColorTile(intl.accentColor(), themeStore.state.accentColor,
        () async {
      Color color = await showDialog(
          context: context,
          child: new AccentColorPickerDialog(
              selected: themeStore.state.accentColor));
      if (color != null) {
        themeStore.dispatch(new ChangeThemeAction(accentColor: color));
        persistAccentColor(color);
      }
    });
  }

  persistBrightness(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ThemeState.kBrightnessKey, value);
    await prefs.commit();
  }

  persistPrimaryColor(ColorSwatch color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(ThemeState.kPrimaryColorKey, Colors.primaries.indexOf(color));
    await prefs.commit();
  }

  persistAccentColor(ColorSwatch color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(ThemeState.kAccentColorKey, Colors.accents.indexOf(color));
    await prefs.commit();
  }

  Widget _buildColorTile(String text, ColorSwatch color, VoidCallback onTap) {
    return new ListTile(
        title: new Row(children: [
          new Expanded(child: new Text(text)),
          new Padding(
              padding: new EdgeInsets.only(right: 14.0),
              child: new ColorTile(color: color, size: 40.0, rounded: true)),
        ]),
        onTap: onTap);
  }
}
