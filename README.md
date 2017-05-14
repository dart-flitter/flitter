# flitter

A new flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](http://flutter.io/).


## Configuration

Create a `main.dart` inside `lib` folder with the following content.

```dart
import 'package:flitter/app.dart' as flitter;
import 'package:flitter/services/flitter_config.dart';

main() {
  Config.init(gitter: const GitterConfig(
      appId: "<GITTER_APP_ID>",
      appSecret: "<GITTER_APP_SECRET>",
      redirectionUrl: "<GITTER_REDIRECTION_URL>"));

  flitter.run();
}
```

[More Infos](https://developer.gitter.im/docs/welcome)