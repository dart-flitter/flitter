library gitter.mentions;

import 'package:jaguar_serializer/serializer.dart';

part 'mention.g.dart';

@GenSerializer(typeInfo: false)
class MentionSerializer extends Serializer<Mention> with _$MentionSerializer {
  @override
  Mention createModel() => new Mention();
}

class Mention {
  String screenName;
  String userId;

  Mention();

  factory Mention.fromJson(Map<String, String> json) =>
      new MentionSerializer().fromMap(json);
}
