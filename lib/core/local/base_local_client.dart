import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BaseLocalClient {
  Future<void> saveJsonList(String key, List<Map<String, dynamic>> jsonList) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = jsonList.map((json) => jsonEncode(json)).toList();
    await prefs.setStringList(key, encodedList);
  }

  Future<List<Map<String, dynamic>>> getJsonList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList(key);

    if (encodedList == null) return [];

    return encodedList
        .map((jsonString) => jsonDecode(jsonString) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clear(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
