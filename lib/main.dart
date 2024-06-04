import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/pages/budget_page.dart';
import 'package:fp_ppb_expense_tracker/pages/category_add_page.dart';
import 'package:fp_ppb_expense_tracker/pages/category_page.dart';
import 'package:fp_ppb_expense_tracker/pages/home_page.dart';
import 'package:fp_ppb_expense_tracker/pages/savings_add_page.dart';
import 'package:fp_ppb_expense_tracker/pages/savings_page.dart';
import 'package:fp_ppb_expense_tracker/pages/user_login_page.dart';
import 'package:fp_ppb_expense_tracker/pages/user_page.dart';
import 'package:fp_ppb_expense_tracker/pages/user_register_page.dart';

import 'constant.dart';
import 'pages/expense_add_page.dart';
import 'pages/expense_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool useMaterial3 = true;
  ThemeMode themeMode = ThemeMode.system;
  ColorSeed colorSelected = ColorSeed.baseColor;
  ColorScheme? imageColorScheme = const ColorScheme.light();
  ColorSelectionMethod colorSelectionMethod = ColorSelectionMethod.colorSeed;

  bool get useLightMode => switch (themeMode) {
        ThemeMode.system =>
          View.of(context).platformDispatcher.platformBrightness ==
              Brightness.light,
        ThemeMode.light => true,
        ThemeMode.dark => false
      };

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = ColorSeed.values[value];
      colorSelectionMethod = ColorSelectionMethod.colorSeed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/expense': (context) => const ExpensePage(),
        '/expense/add': (context) => const ExpenseAddPage(),
        '/category': (context) => const CategoryPage(),
        '/category/add': (context) =>
            const CategoryAddPage(iconDataList: iconDataList),
        '/budget': (context) => const BudgetPage(),
        '/savings': (context) => const SavingsPage(),
        '/savings/add': (context) => const SavingsAddPage(),
        '/user': (context) => const UserPage(),
        '/user/login': (context) => const UserLoginPage(),
        '/user/register': (context) => const UserRegisterPage(),
      },
      initialRoute: '/',
      home: const HomePage(),
      themeMode: themeMode,
      theme: ThemeData(
          useMaterial3: useMaterial3,
          colorSchemeSeed:
              colorSelectionMethod == ColorSelectionMethod.colorSeed
                  ? colorSelected.color
                  : null,
          colorScheme: colorSelectionMethod == ColorSelectionMethod.image
              ? imageColorScheme
              : null,
          brightness: Brightness.light),
      darkTheme: ThemeData(
        useMaterial3: useMaterial3,
        colorSchemeSeed: colorSelectionMethod == ColorSelectionMethod.colorSeed
            ? colorSelected.color
            : imageColorScheme!.primary,
        brightness: Brightness.dark,
      ),
    );
  }
}
