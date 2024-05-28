import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/expense_page.dart';
import 'pages/expense_add_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/expense': (context) => const ExpensePage(),
        '/expense/add': (context) => const ExpenseAddPage(),
      },
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
