import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

/*
 * Configuration inside config.yaml
 *
 * gitter:
 *   app_id: APP_ID
 *   app_secret: APP_SECRET
 *   redirection_url: URL
 */

class FlitterConfig {
  static FlitterConfig _instance;

  factory FlitterConfig() => _instance ??= new FlitterConfig._();

  GitterConfig _gitter;

  FlitterConfig._();

  init() async {
    String cfg = await rootBundle.loadString("config.yaml");
    Map yaml = loadYaml(cfg);
    _gitter = new GitterConfig(yaml["gitter"]);
  }

  GitterConfig get gitter => _gitter;
}

class GitterConfig {
  final Map<String, dynamic> _map;

  GitterConfig(this._map);

  String get appId => _map["app_id"];

  String get appSecret => _map["app_secret"];

  String get redirectionUrl => _map["redirection_url"];
}

final FlitterConfig flitterConfig = new FlitterConfig();
