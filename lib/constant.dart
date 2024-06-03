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
  stats(4),
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
    icon: Icon(Icons.bar_chart_outlined),
    label: 'Stats',
    selectedIcon: Icon(Icons.bar_chart_rounded),
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outlined),
    label: 'User',
    selectedIcon: Icon(Icons.person_rounded),
  ),
];

const List<IconData> iconDataList = [
  Icons.home,
  Icons.money,
  Icons.category,
  Icons.bar_chart,
  Icons.person,
  Icons.send,
  Icons.trolley,
  Icons.style,
  Icons.face,
  Icons.shopping_basket,
  Icons.ac_unit,
  Icons.access_alarm,
  Icons.access_alarms,
  Icons.access_time,
  Icons.accessibility,
  Icons.accessibility_new,
  Icons.accessible,
  Icons.accessible_forward,
  Icons.account_balance,
  Icons.account_balance_wallet,
  Icons.account_box,
  Icons.account_circle,
  Icons.adb,
  Icons.add,
  Icons.add_a_photo,
  Icons.add_alarm,
  Icons.add_alert,
  Icons.add_box,
  Icons.add_call,
  Icons.add_chart,
  Icons.add_circle,
  Icons.add_comment,
  Icons.add_ic_call,
  Icons.add_location,
  Icons.add_moderator,
  Icons.add_photo_alternate,
  Icons.add_shopping_cart,
  Icons.add_to_drive,
  Icons.add_to_home_screen,
  Icons.add_to_photos,
  Icons.add_to_queue,
  Icons.adjust,
  Icons.agriculture,
  Icons.airline_seat_flat,
];
