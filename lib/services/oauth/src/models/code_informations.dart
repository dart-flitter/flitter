library oauth.code_informations;

class CodeInformations {
  final String url;
  final Map<String, String> params;
  final bool force;

  CodeInformations(this.url, this.params, {this.force: false});
}
