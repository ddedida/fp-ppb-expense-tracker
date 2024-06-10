import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/model/settings.dart';

class SettingPage extends StatefulWidget {
  final void Function(ThemeMode) onThemeModeChange;
  final AppSettings settings;
  const SettingPage(
      {super.key, required this.settings, required this.onThemeModeChange});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late AppSettings settings;
  @override
  void initState() {
    super.initState();
    settings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                trailing: DropdownButton(
                  value: settings.themeMode,
                  onChanged: (ThemeMode? value) {
                    setState(() {
                      widget.onThemeModeChange(value ?? ThemeMode.system);
                      settings.themeMode = value!;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('system'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('dark'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
