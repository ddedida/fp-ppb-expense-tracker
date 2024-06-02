import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/components/navigation_bars.dart';
import 'package:fp_ppb_expense_tracker/components/navigation_transition.dart';
import 'package:fp_ppb_expense_tracker/constant.dart';
import 'package:fp_ppb_expense_tracker/pages/category_page.dart';
import 'package:fp_ppb_expense_tracker/pages/expense_page.dart';
import 'package:fp_ppb_expense_tracker/pages/home_page.dart';

class AppTemplate extends StatefulWidget {
  const AppTemplate({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
    required this.colorSelected,
  });

  final bool useLightMode;
  final void Function(bool) handleBrightnessChange;
  final void Function(int) handleColorSelect;
  final ColorSeed colorSelected;

  @override
  State<AppTemplate> createState() => _AppTemplateState();
}

class _AppTemplateState extends State<AppTemplate>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  int screenIndex = ScreenSelected.home.value;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleScreenSelect(int index) {
    setState(() {
      screenIndex = index;
      controller.reverse();
    });
  }

  Widget createScreen(ScreenSelected screenSelected) {
    switch (screenSelected) {
      case ScreenSelected.home:
        return const HomePage();
      case ScreenSelected.expense:
        return const ExpensePage();
      case ScreenSelected.category:
        return const CategoryPage();
      case ScreenSelected.stats:
        return const Center(child: Text('Stats'));
      case ScreenSelected.user:
        return const Center(child: Text('User'));
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Navigator(
              pages: [
                MaterialPage(
                  child: child!,
                )
              ],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(builder: (context) {
                  return NavigationTransition(
                    animationController: controller,
                    railAnimation: railAnimation,
                    navigationRail: NavigationRail(
                      destinations: navRailDestinations,
                      selectedIndex: screenIndex,
                      onDestinationSelected: handleScreenSelect,
                    ),
                    navigationBar: NavigationBars(
                      selectedIndex: screenIndex,
                      onSelectItem: handleScreenSelect,
                      navDestinations: appBarDestinations,
                    ),
                    body: createScreen(ScreenSelected.values[screenIndex]),
                    appBar: AppBar(
                      title: const Text(
                        "Expense Tracker",
                      ),
                    ),
                  );
                });
              });
        });
  }

  final List<NavigationRailDestination> navRailDestinations = appBarDestinations
      .map(
        (destination) => NavigationRailDestination(
          icon: Tooltip(
            message: destination.label,
            child: destination.icon,
          ),
          selectedIcon: Tooltip(
            message: destination.label,
            child: destination.selectedIcon,
          ),
          label: Text(destination.label),
        ),
      )
      .toList();
}
