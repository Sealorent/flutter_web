import 'dart:async';
import 'dart:convert';

import 'package:alice_lightweight/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/change_password/change_password_screen.dart';
import 'package:pesantren_flutter/ui/account/privacy_policy/privacy_policy.dart';
import 'package:pesantren_flutter/ui/account/term_and_condition/term_and_condition.dart';
import 'package:pesantren_flutter/ui/account/view_profile/view_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/login/login_pesantren_screen.dart';
import 'package:pesantren_flutter/ui/login/login_user_screen.dart';
import 'package:pesantren_flutter/utils/my_snackbar.dart';
import 'package:pesantren_flutter/utils/webview.dart';
import 'package:pesantren_flutter/widget/social_media.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/response/pesantren_login_response.dart';
import '../../network/response/setting_response.dart';
import '../../network/response/student_login_response.dart';
import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';
import '../../utils/show_image.dart';

class AccountScreen extends StatefulWidget {
  Alice? alice;

  AccountScreen(this.alice);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  void _logoutBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return Container(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                      color: MyColors.grey_20,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Anda yakin akan keluar akun?",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                        ),
                        child: const Text("Batal"),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(18.0)))),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove(PrefData.pesantren);
                          prefs.remove(PrefData.student);
                          prefs.remove(PrefData.setting);
                          prefs.remove(PrefData.role);
                          prefs.remove(PrefData.TAHUN_AJARAN);
                          prefs.clear();

                          Get.offAll(LoginUserScreen());
                        },
                        child: Padding(
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
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  StudentLoginResponse? _user;
  PesantrenLoginResponse? _pesantren;

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.student);
    var objectStudent =
        StudentLoginResponse.fromJson(json.decode(student ?? ""));

    setState(() {
      _user = objectStudent;
    });
  }

  Future<void> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren = pesantrenLoginResponseFromJson(pesantren ?? "");
    setState(() {
      _pesantren = objectpesantren;
    });
  }

  @override
  void initState() {
    _getPesantren();
    _getSetting();
    super.initState();
  }

  SettingResponse? _settingResponse;

  Future<void> _getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.setting);
    print("gilang $student");
    var objectStudent = SettingResponse.fromJson(json.decode(student ?? ""));

    setState(() {
      _settingResponse = objectStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Akun",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      ScreenUtils(context).navigateTo(
                          ShowImage(_user?.photo ?? "", _user?.nama ?? ""));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(_user?.photo ?? ""),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 4.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _user?.nama ?? "",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "NIS : ${_user?.nis ?? ""}",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _user?.kelas ?? "",
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            ScreenUtils(context)
                                .navigateTo(ViewProfileScreen());
                          },
                          child: Text(
                            "Lihat profil",
                            style: TextStyle(color: MyColors.primary),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(),
            InkWell(
              onTap: () {
                ScreenUtils(context).navigateTo(ChangePasswordScreen());
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text("Ganti password"),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                ScreenUtils(context).navigateTo(CustomWebView(
                    "https://epesantren.co.id/syarat-ketentuan-mobile-view/",
                    "Syarat dan Ketentuan"));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text("Syarat dan Ketentuan"),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () {
                ScreenUtils(context).navigateTo(CustomWebView(
                    "https://epesantren.co.id/kebijakan-privasi-mobile-view/",
                    "Kebijakan Privasi"));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text("Kebijakan Privasi"),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            Divider(),
            InkWell(
              onTap: () async {
                final InAppReview inAppReview = InAppReview.instance;

                if (await inAppReview.isAvailable()) {
                  inAppReview.requestReview();
                } else {
                  MySnackbar(context).errorSnackbar(
                      "Aplikasi ini belum tersedia di playstore");
                }
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text("Beri Rating"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "v1.1.1",
                      style: TextStyle(color: MyColors.grey_50),
                    ),
                    Spacer(),
                    Icon(
                      Icons.keyboard_arrow_right,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            // Divider(),
            // InkWell(
            //   onTap: () async {
            //     widget.alice?.showInspector();
            //   },
            //   child: Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     child: Row(
            //       children: [
            //         Text("Inspeksi API"),
            //         Spacer(),
            //         Icon(
            //           Icons.keyboard_arrow_right,
            //           size: 20,
            //         )
            //       ],
            //     ),
            //   ),
            // ),
            Divider(),
            InkWell(
              onTap: () {
                _logoutBottomSheetMenu();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Text("Keluar akun"),
                    Spacer(),
                    Icon(
                      Icons.exit_to_app,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            // Divider(),
            // InkWell(
            //   onTap: (){
            //     widget.alice?.showInspector();
            //     print("alice ${widget.alice}");
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            //     child: Row(
            //       children: [
            //         Text("Inspector"),
            //         Spacer(),
            //         Icon(Icons.deblur, size: 20,)
            //       ],
            //     ),
            //   ),
            // ),

            Divider(),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SocialMedia(_settingResponse, context),
            )
          ],
        ),
      ),
    );
  }
}
