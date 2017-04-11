import 'package:intl/intl.dart';

String allConversations() =>
    Intl.message("All Conversations", name: "allConversations", args: []);

String people() => Intl.message("People", name: "people", args: []);

String typeChatMessage() => Intl.message("Touch here to type a chat message.",
    name: "typeChatMessage", args: []);

String communities() =>
    Intl.message("Communities", name: "communities", args: []);

String logout() => Intl.message("Logout", name: "logout", args: []);
