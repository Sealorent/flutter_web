import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/login/login_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';
import '../../widget/progress_loading.dart';

class LoginPesantrenScreen extends StatefulWidget {
  const LoginPesantrenScreen({Key? key}) : super(key: key);

  @override
  State<LoginPesantrenScreen> createState() => _LoginPesantrenScreenState();
}

class _LoginPesantrenScreenState extends State<LoginPesantrenScreen> {

  Future<void> _getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.containsKey(PrefData.accessToken);
    if (isLoggedIn) {
      // ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
    } else {
      // ScreenUtils(context).navigateTo(LoginPage(), replaceScreen: true);
    }
  }

  TextEditingController pesantrenController = TextEditingController();
  String? _currentSelectedValue;

  final _currencies = [
    "Pondok Pesantren Nurul Jadid",
    "Pondok Pesantren Darulloh",
    "Personal",
    "Shopping",
    "Medical",
    "Rent",
    "Movie",
    "Salary"
  ];

  List<String> getSuggestion(String query){
    return _currencies.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SizedBox(
              width: size.width,
              child: SvgPicture.asset(
                "assets/background_mosque.svg",
                fit: BoxFit.fill,
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset("assets/circle_logo.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: pesantrenController,
                          decoration: InputDecoration(
                              errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                              hintText: 'Pilih Pesantren',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                      ),
                      suggestionsCallback: (pattern) {
                        return getSuggestion(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          title: Text(suggestion?.toString() ?? ""),
                        );
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      onSuggestionSelected: (suggestion) {
                        if(suggestion != null){
                          pesantrenController.text = suggestion.toString();
                        }
                      },
                      validator: (value) {
                        // if (value.isEmpty) {
                        //   return 'Please select a city';
                        // }
                      },
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text("Cari name pesantren, atau ketik kode pesantren"),
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
                      ScreenUtils(context).navigateTo(LoginUserScreen());
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
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset("assets/bottom_background.svg"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text("Version 1.0.0"),
              ),
            ),

          ],
        )
    );
  }
}
