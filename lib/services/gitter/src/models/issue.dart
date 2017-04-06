library gitter.issue;

class Issue {
  final String number;

  Issue.fromJson(Map<String, String> json) : number = json['number'];
}
