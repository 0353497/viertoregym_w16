import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<dynamic> readJson(String path) async {
    final json = await rootBundle.loadString(path);
    final data = await jsonDecode(json);
    return data;
  }

  static Future<List> getStudios() async {
    final data = await readJson("assets/Data.json");
    return data["studios"];
  }

  static Future<List> getBroadcastInformation() async {
    final data = await readJson("assets/Data.json");
    return data["broadcast_information"] ?? [];
  }

  static Future<Map<String, dynamic>?> getMembershipForUser(
    String username,
  ) async {
    final data = await readJson("assets/Data.json");
    final users = data["users"] as Map<String, dynamic>?;
    final subscriptionTypes =
        data["subscription_types"] as Map<String, dynamic>?;

    if (users == null || subscriptionTypes == null) {
      return null;
    }

    final user = users[username.toLowerCase()] as Map<String, dynamic>?;
    if (user == null) {
      return null;
    }

    final subscription = user["subscription"] as Map<String, dynamic>?;
    final subscriptionType = subscription?["type"]?.toString();
    final subscriptionInfo = subscriptionType != null
        ? subscriptionTypes[subscriptionType] as Map<String, dynamic>?
        : null;

    return {
      "first_name": user["first_name"]?.toString(),
      "last_name": user["last_name"]?.toString(),
      "date_of_birth": user["date_of_birth"]?.toString(),
      "subscription_type": subscriptionType,
      "expiration_date": subscription?["expiration_date"]?.toString(),
      "monthly_price_eur": subscriptionInfo?["monthly_price_eur"]?.toString(),
    };
  }
}
