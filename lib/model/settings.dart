import 'package:flutter/material.dart';

class AppSettingsFields {
  static const String appColorScheme = 'appColorScheme';
  static const String moneySymbol = 'moneySymbol';
  static const String currency = 'currency';
  static const String themeMode = 'themeMode';
}

class AppSettings {
  late String appColorScheme;
  late String moneySymbol;
  late String currency;
  late ThemeMode themeMode;

  AppSettings({
    required this.appColorScheme,
    required this.moneySymbol,
    required this.currency,
    required this.themeMode,
  });

  AppSettings copy({
    String? appColorScheme,
    String? moneySymbol,
    String? currency,
    ThemeMode? themeMode,
  }) =>
      AppSettings(
        appColorScheme: appColorScheme ?? this.appColorScheme,
        moneySymbol: moneySymbol ?? this.moneySymbol,
        currency: currency ?? this.currency,
        themeMode: themeMode ?? this.themeMode,
      );

  AppSettings setAppColorScheme(String appColorScheme) =>
      copy(appColorScheme: appColorScheme);

  AppSettings setMoneySymbol(String moneySymbol) =>
      copy(moneySymbol: moneySymbol);

  AppSettings setCurrency(String currency) => copy(currency: currency);

  AppSettings setThemeMode(ThemeMode themeMode) => copy(themeMode: themeMode);

  static AppSettings fromJson(Map<String, Object?> json) => AppSettings(
        appColorScheme: json[AppSettingsFields.appColorScheme] as String,
        moneySymbol: json[AppSettingsFields.moneySymbol] as String,
        currency: json[AppSettingsFields.currency] as String,
        themeMode: switch (json[AppSettingsFields.themeMode]) {
          'ThemeMode.light' => ThemeMode.light,
          'ThemeMode.dark' => ThemeMode.dark,
          Object() => ThemeMode.system,
          null => ThemeMode.system,
        },
      );

  Map<String, Object?> toJson() => {
        AppSettingsFields.appColorScheme: appColorScheme,
        AppSettingsFields.moneySymbol: moneySymbol,
        AppSettingsFields.currency: currency,
        AppSettingsFields.themeMode: themeMode.toString(),
      };
}
