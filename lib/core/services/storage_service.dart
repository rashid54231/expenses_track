import 'package:shared_preferences/shared_preferences.dart';

class StorageService {

  static Future saveUserId(String id) async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", id);

  }

  static Future<String?> getUserId() async {

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("user_id");

  }

}