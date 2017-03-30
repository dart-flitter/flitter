import 'package:intl/intl.dart';

String allConversations() =>
    Intl.message("All Conversations", name: "allConversations", args: []);

String people() => Intl.message("People", name: "people", args: []);

String typeChatMessage() => Intl.message("Touch here to type a chat message.",
    name: "typeChatMessage", args: []);
