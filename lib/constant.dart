import 'package:flutter/material.dart';

const double mediumWidthBreakpoint = 1000;
const double largeWidthBreakpoint = 1500;

const double transitionLength = 500;

// Whether the user has chosen a theme color via a direct [ColorSeed] selection,
// or an image [ColorImageProvider].
enum ColorSelectionMethod {
  colorSeed,
  image,
}

enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

enum ScreenSelected {
  home(0),
  expense(1),
  category(2),
  budget(3),
  savings(4),
  user(5);

  const ScreenSelected(this.value);
  final int value;
}

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    label: 'Home',
    selectedIcon: Icon(Icons.home_rounded),
  ),
  NavigationDestination(
    icon: Icon(Icons.money_outlined),
    label: 'Expense',
    selectedIcon: Icon(Icons.money_rounded),
  ),
  NavigationDestination(
    icon: Icon(Icons.category_outlined),
    label: 'Category',
    selectedIcon: Icon(Icons.category_rounded),
  ),
  NavigationDestination(
    icon: Icon(Icons.paid_rounded),
    label: 'Budget',
    selectedIcon: Icon(Icons.paid_rounded),
  ),
  NavigationDestination(
    icon: Icon(Icons.savings_outlined),
    label: 'Savings',
    selectedIcon: Icon(Icons.savings_rounded),
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outlined),
    label: 'User',
    selectedIcon: Icon(Icons.person_rounded),
  ),
];

const List<IconData> iconDataList = [
  Icons.home,
  Icons.sports_soccer,
  Icons.fastfood,
  Icons.videogame_asset,
  Icons.stacked_line_chart,
  Icons.sports_motorsports,
  Icons.emoji_transportation,
  Icons.shopping_cart,
  Icons.medication,
  Icons.school,
  Icons.card_giftcard,
  Icons.shield,
  Icons.monetization_on,
  Icons.favorite,
  Icons.star,
];
