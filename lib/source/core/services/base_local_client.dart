import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BaseLocalClient {
//Dependency Injection
final SharedPreferences prefs;

  BaseLocalClient({required this.prefs});


  Future<void> saveCache(String key, Map<String, dynamic> data) async {
    final jsonString = jsonEncode(data);
    await prefs.setString(key, jsonString);
  }


  /// Retrieve and decode JSON string into Map from SharedPreferences
  Map<String, dynamic>? getCache(String key) {
    final jsonString = prefs.getString(key);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }


  /// Optional: Clear cache
  Future<void> clearCache(String key) async {
    await prefs.remove(key);
  }


  /// Optional: Check if cache exists
  bool hasCache(String key) {
    return prefs.containsKey(key);
  }

  
}
