import 'package:flutter/material.dart';
import 'package:fp_ppb_expense_tracker/components/server_development_button_group.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/services/auth.dart';
import 'package:fp_ppb_expense_tracker/infrastructure/services/shared_preferences.dart';
import 'package:fp_ppb_expense_tracker/model/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final AuthMethods _authMethods = AuthMethods();
  User? user;
  var isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    SharedPreference.getUser().then((value) {
      setState(() {
        user = value;
        if (user != null) {
          isLoggedIn = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/user/login').then((_) {
                    SharedPreference.getUser().then((value) {
                      setState(() {
                        user = value;
                        if (user != null) {
                          isLoggedIn = true;
                        }
                      });
                    });
                  });
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/user/register');
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${user!.username}'),
            const ServerDevelopmentButtonGroup(),
            ElevatedButton(
              onPressed: () {
                SharedPreference.clearSharedPreference();
                _authMethods.logout();

                Navigator.pushNamed(context, '/user/login');
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
