import 'dart:convert';

import 'package:flutter/services.dart';

class JsonReader {
  static Future<dynamic> readJson(String path) async {
    final json = await rootBundle.loadString(path);
    final data = await jsonDecode(json);
    return data;
  }
}
