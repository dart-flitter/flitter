import 'dart:io';

main() {
  File file = new File("lib/main.dart");
  if (!file.existsSync()) {
    file.createSync(recursive: true);
    file.writeAsStringSync(
        _generate(Platform.environment["GITTER_APP_ID"],
            Platform.environment["GITTER_APP_SECRET"]));
  }
}


String _generate(String appId, String appSecret) =>
    '''
import 'package:flitter/app.dart' as flitter;
import 'package:flitter/services/flitter_config.dart';

main() {
  Config.init(
      gitter: const GitterConfig(
          appId: "$appId",
          appSecret: "$appSecret",
          redirectionUrl: "http://localhost:8080/"));

  flitter.run();
}

''';