library gitter.mentions;

class Mention {
  final String screenName;
  final String userId;

  Mention.fromJson(Map<String, String> json)
      : screenName = json['screenName'],
        userId = json['userId'];
}
