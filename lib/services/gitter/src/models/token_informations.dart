library gitter.token_informations;

import 'package:flitter/services/oauth/oauth.dart';

class GitterTokenInformations extends TokenInformations {
  GitterTokenInformations(AppInformations appInformations, String code)
      : super(
            "https://gitter.im/login/oauth/token",
            {
              "client_id": appInformations.appId,
              "client_secret": appInformations.appSecret,
              "code": code,
              "redirect_uri": appInformations.redirectUri,
              "grant_type": "authorization_code",
            },
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json"
            },
            isPost: true);
}
