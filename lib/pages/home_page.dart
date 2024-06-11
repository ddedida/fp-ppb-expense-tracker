import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/components/navigation_bars.dart';
import 'package:fp_ppb_expense_tracker/constant.dart';
import 'package:fp_ppb_expense_tracker/pages/budget_page.dart';
import 'package:fp_ppb_expense_tracker/pages/category_page.dart';
import 'package:fp_ppb_expense_tracker/pages/expense_page.dart';
import 'package:fp_ppb_expense_tracker/pages/user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = ScreenSelected.home.value;
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      controller.reverse();
    });
  }

  Widget createScreen(ScreenSelected screenSelected) {
    switch (screenSelected) {
      case ScreenSelected.home:
        return const ExpensePage();
      case ScreenSelected.expense:
        return const ExpensePage();
      case ScreenSelected.category:
        return const CategoryPage();
      case ScreenSelected.budget:
        return const BudgetPage();
      case ScreenSelected.user:
        return const UserPage();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createScreen(ScreenSelected.values[selectedIndex]),
      bottomNavigationBar: NavigationBars(
        selectedIndex: selectedIndex,
        onSelectItem: _onItemTapped,
        navDestinations: appBarDestinations,
      ),
    );
  }
}
