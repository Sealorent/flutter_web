import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/login/login_event.dart';
import 'package:pesantren_flutter/ui/login/login_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/screen_utils.dart';
import '../../widget/progress_loading.dart';
import 'login_bloc.dart';
import 'login_state.dart';

class LoginPesantrenScreen extends StatefulWidget {
  const LoginPesantrenScreen({Key? key}) : super(key: key);

  @override
  State<LoginPesantrenScreen> createState() => _LoginPesantrenScreenState();
}

class _LoginPesantrenScreenState extends State<LoginPesantrenScreen> {
  late LoginBloc bloc;
  TextEditingController pesantrenController = TextEditingController();
  String? _currentSelectedValue;
  bool _isLoading = false;

  final _currencies = [""];

  List<String> getSuggestion(String query) {
    return _currencies
        .where((element) => element.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void loginListener(BuildContext context, LoginState state) async {
    if (state is LoginLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is LoginSuccess) {
      setState(() {
        _isLoading = false;
        ScreenUtils(context).navigateTo(LoginUserScreen());
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        // MySnackbar(context)
        //     .errorSnackbar("Login gagal, silahkan login ulang");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  @override
  void initState() {
    bloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocListener<LoginBloc, LoginState>(
        listener: loginListener,
        child: Scaffold(
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
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorStyle: const TextStyle(
                                    color: Colors.redAccent, fontSize: 16.0),
                                hintText: 'Pesantren',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0))),
                          ),
                          suggestionsCallback: (pattern) {
                            return getSuggestion(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(suggestion?.toString() ?? ""),
                            );
                          },
                          transitionBuilder:
                              (context, suggestionsBox, controller) {
                            return suggestionsBox;
                          },
                          onSuggestionSelected: (suggestion) {
                            if (suggestion != null) {
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
                      SizedBox(
                        height: 5,
                      ),
                      Text("Cari name pesantren, atau ketik kode pesantren"),
                      SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? ProgressLoading()
                          : ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0)))),
                              onPressed: () async {
                                var code = pesantrenController.text;
                                bloc.add(LoginPesantren(code));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: Text(
                        "Hapus riwayat",
                        style: TextStyle(color: MyColors.primary),
                      )),
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
            )));
  }
}
