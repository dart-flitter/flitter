import 'package:intl/intl.dart';

String allConversations() =>
    Intl.message("All Conversations", name: "allConversations", args: []);

String people() => Intl.message("People", name: "people", args: []);

String typeChatMessage() => Intl.message("Touch here to type a chat message.",
    name: "typeChatMessage", args: []);

String communities() =>
    Intl.message("Communities", name: "communities", args: []);

String logout() => Intl.message("Logout", name: "logout", args: []);

String theme() => Intl.message("Theme", name: "theme", args: []);

String settings() => Intl.message("Settings", name: "settings", args: []);

String darkMode() => Intl.message("Dark mode", name: "darkMode", args: []);

String primaryColor() =>
    Intl.message("Primary Color", name: "primaryColor", args: []);

String accentColor() =>
    Intl.message("Accent Color", name: "accentColor", args: []);
