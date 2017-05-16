import 'package:meta/meta.dart';

class Config {
  final GitterConfig gitter;

  static Config _instance;

  Config._({this.gitter});

  static init({@required GitterConfig gitter}) =>
      _instance ??= new Config._(gitter: gitter);

  static Config getInstance() => _instance;
}

class GitterConfig {
  final String appId;
  final String appSecret;
  final String redirectionUrl;

  const GitterConfig(
      {@required this.appId,
      @required this.appSecret,
      @required this.redirectionUrl});
}
