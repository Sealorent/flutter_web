import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/splashscreen/splash_screen.dart';

void main() {
  Alice alice = Alice();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: MyColors.primary,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MyApp(alice));
}

class MyApp extends StatelessWidget {
  Alice? alice;

  MyApp(this.alice);
  //alice?.showInspector();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(MyColors.materialPrimaryColorCode, MyColors.primaryColorCodes),
        primaryColor: Colors.red,
      ),
      home: SplashScreen(),
    );
  }
}
