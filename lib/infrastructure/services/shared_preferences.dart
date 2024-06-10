import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/settings.dart';
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
      return User.fromJson(json.decode(user));
    }
    return null;
  }

  static Future<void> saveSetting(AppSettings settings) async {
    final SharedPreferences prefs = await _instance;
    await prefs.setString('settings', json.encode(settings.toJson()));
  }

  static Future<AppSettings> getSetting() async {
    final SharedPreferences prefs = await _instance;
    final String? settings = prefs.getString('settings');
    if (settings != null) {
      return AppSettings.fromJson(json.decode(settings));
    }
    return AppSettings(
      appColorScheme: "red",
      themeMode: ThemeMode.system,
      currency: "USD",
      moneySymbol: "\$",
    );
  }
}
