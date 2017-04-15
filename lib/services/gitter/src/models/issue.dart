library gitter.issue;

import 'package:jaguar_serializer/serializer.dart';

part 'issue.g.dart';

@GenSerializer(typeInfo: false)
class IssueSerializer extends Serializer<Issue> with _$IssueSerializer {
  @override
  Issue createModel() => new Issue();
}

class Issue {
  String number;

  Issue();

  factory Issue.fromJson(Map<String, String> json) =>
      new IssueSerializer().fromMap(json);
}
