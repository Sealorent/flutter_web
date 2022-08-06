import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';
import '../../widget/progress_loading.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({Key? key}) : super(key: key);

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {
  Future<void> _getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.containsKey(PrefData.accessToken);
    if (isLoggedIn) {
      // ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
    } else {
      // ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
    }
  }

  bool _passwordVisible = false;
  TextEditingController nisController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.primary,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColors.grey_60,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset("assets/bottom_background.svg"),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Image.asset("assets/circle_logo.png", height: 100,),
                  SizedBox(height: 40,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Assalamu’alaikum, selamat datang di"),
                      SizedBox(height: 10,),
                      Text("Ponpes Al-Hikmah Gresik", style: TextStyle(fontSize: 22),),
                    ],
                  ),
                  SizedBox(height: 40,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'NIS Santri',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: MyColors.primary,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(
                            () {
                              _passwordVisible = !_passwordVisible;
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text("Lupa password?", style: TextStyle(color: MyColors.primary,), textAlign: TextAlign.end,),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)
                            )
                        )
                    ),
                    onPressed: () async{
                      ScreenUtils(context).navigateTo(DashboardScreen());
                    },
                    child:  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Lanjut",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                ?.apply(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Center(child: Text("Hapus riwayat", style: TextStyle(color: MyColors.primary),)),
                  SizedBox(height: 20,),
                  Divider(),
                  SizedBox(height: 20,),
                  Center(child: Text("Butuh bantuan?")),
                  SizedBox(height: 5,),
                  Center(child: Text("Hubungi admin", style: TextStyle(color: MyColors.primary),)),
                ],
              ),
            ),
          ),
        ]));
  }
}
