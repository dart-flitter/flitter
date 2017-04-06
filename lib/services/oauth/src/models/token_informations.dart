library oauth.token_informations;

class TokenInformations {
  final String url;
  final Map<String, String> params;
  final Map<String, String> headers;
  final bool isPost;
  final bool force;

  TokenInformations(this.url, this.params,
      {this.headers, this.isPost: false, this.force: false});
}
