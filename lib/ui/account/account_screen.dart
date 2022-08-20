import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/view_profile/view_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/login/login_pesantren_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  void _logoutBottomSheetMenu(){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder){
          return Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                      color: MyColors.grey_20,
                      borderRadius:
                      BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Anda yakin akan keluar akun?",),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                              )
                          ),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0)
                                )
                            )
                        ),
                        onPressed: () async{
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.clear();
                          ScreenUtils(context).navigateTo(LoginPesantrenScreen(), replaceScreen: true);
                        },
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Keluar",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    ?.apply(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0,
        title: Text("Akun", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://preview.keenthemes.com/metronic-v4/theme_rtl/assets/pages/media/profile/profile_user.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 4.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mulya Lukman Lazuardi",
                          style: TextStyle(
                              fontSize: 20),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "NIS : 112092",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          "Kelas Prapersiapan Putra 1",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            ScreenUtils(context).navigateTo(ViewProfileScreen());
                          },
                          child: Text(
                            "Lihat profil",
                            style: TextStyle(
                                color: MyColors.primary),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(),
            InkWell(
              onTap: (){

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Text("Ganti password"),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, size: 20,)
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Text("Syarat dan Ketentuan"),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, size: 20,)
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Text("Kebijakan Privasi"),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, size: 20,)
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Text("Beri Rating"),
                    SizedBox(width: 10,),
                    Text("v1.0.0", style: TextStyle(color: MyColors.grey_50),),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_right, size: 20,)
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){
                _logoutBottomSheetMenu();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Row(
                  children: [
                    Text("Keluar akun"),
                    Spacer(),
                    Icon(Icons.exit_to_app, size: 20,)
                  ],
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.firefox, color: MyColors.grey_60,),
                  SizedBox(width: 15,),
                  FaIcon(FontAwesomeIcons.instagram, color: Colors.red,),
                  SizedBox(width: 15,),
                  FaIcon(FontAwesomeIcons.facebook, color: Colors.blueAccent,),
                  SizedBox(width: 15,),
                  FaIcon(FontAwesomeIcons.youtube, color: Colors.red,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
