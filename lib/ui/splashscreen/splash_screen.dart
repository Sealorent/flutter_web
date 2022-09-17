import 'dart:async';

import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/login/login_pesantren_screen.dart';
import 'package:pesantren_flutter/ui/login/login_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';
import '../../widget/progress_loading.dart';

class SplashScreen extends StatefulWidget {

  Alice? alice;

  SplashScreen(this.alice);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _getPrefData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.containsKey(PrefData.student);
      if (isLoggedIn) {
        ScreenUtils(context).navigateTo(DashboardScreen(widget.alice), replaceScreen: true);
      } else {
        ScreenUtils(context).navigateTo(LoginUserScreen(), replaceScreen: true);
      }
    }

    Timer(Duration(seconds: 2), () {
      _getPrefData();
    });

    final _size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: _size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                width: 120,
              ),
              SizedBox(
                height: 50,
              ),
              ProgressLoading(
                size: 10,
                stroke: 1,
              )
            ],
          ),
        ));
  }
}
