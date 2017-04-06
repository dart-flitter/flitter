library gitter.code_informations;

import 'package:flitter/services/oauth/oauth.dart';

class GitterCodeInformations extends CodeInformations {
  GitterCodeInformations(AppInformations appInformations, {bool force: false})
      : super(
          "https://gitter.im/login/oauth/authorize",
          {
            "client_id": appInformations.appId,
            "response_type": "code",
            "redirect_uri": appInformations.redirectUri,
          },
          force: force,
        );
}
