library gitter.mentions;

import 'package:jaguar_serializer/serializer.dart';

part 'mention.g.dart';

@GenSerializer(typeInfo: false)
class MentionSerializer extends Serializer<Mention> with _$MentionSerializer {
  @override
  Mention createModel() => new Mention();
}

class Mention {
  static final serializer = new MentionSerializer();
  String screenName;
  String userId;

  Mention();

  factory Mention.fromJson(Map<String, String> json) =>
      serializer.fromMap(json);

  @override
  String toString() => serializer.toMap(this).toString();
}
