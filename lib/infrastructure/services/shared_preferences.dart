import 'dart:convert';

import 'package:fp_ppb_expense_tracker/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final Future<SharedPreferences> _instance =
      SharedPreferences.getInstance();

  static Future<void> clearSharedPreference() async {
    final SharedPreferences prefs = await _instance;
    prefs.clear();
  }

  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await _instance;
    await prefs.setString('user', json.encode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final SharedPreferences prefs = await _instance;
    final String? user = prefs.getString('user');
    if (user != null) {
      print(user);
      return User.fromJson(json.decode(user));
    }
    return null;
  }
}
