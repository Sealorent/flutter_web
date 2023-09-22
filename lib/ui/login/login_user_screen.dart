import 'dart:async';
import 'package:alice_lightweight/alice.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pesantren_flutter/network/response/pesantren_login_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/forgot_password/forgot_password.dart';
import 'package:pesantren_flutter/ui/login/login_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../widget/progress_loading.dart';
import 'login_bloc.dart';
import 'login_state.dart';

// ignore: must_be_immutable
class LoginUserScreen extends StatefulWidget {
  Alice? alice;

  LoginUserScreen({super.key, this.alice});

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {


  Future<void> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren = pesantrenLoginResponseFromJson(pesantren ?? "");
    // var getFcmToken = prefs.getString(PrefData.fcmToken);
    // print("pesantren: $getFcmToken");
    setState(() {
      // fcmToken = getFcmToken;
      _pesantrenLoginResponse = objectpesantren;
    });
  }

  Future<List<String>> _getKodePesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getStringList(PrefData.kodePesantren);
    return pesantren ?? [];
  }

  Future<void> saveKodePesantren(String kPesantren) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var kodepesantrens = await _getKodePesantren();
    kodepesantrens.add(kPesantren);
    kodepesantrens = kodepesantrens.toSet().toList();
    prefs.setStringList(PrefData.kodePesantren, kodepesantrens);
  }

  Future<List<String>> _getKodeStudent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getStringList(PrefData.nisSantri);
    return pesantren ?? [];
  }

  Future<void> saveKodeStudnet(String kPesantren) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var kodepesantrens = await _getKodeStudent();
    kodepesantrens.add(kPesantren);
    kodepesantrens = kodepesantrens.toSet().toList();
    prefs.setStringList(PrefData.nisSantri, kodepesantrens);
  }

  
  PesantrenLoginResponse? _pesantrenLoginResponse;
  String? fcmToken;
  bool _passwordVisible = false;
  TextEditingController nisController = TextEditingController();
  TextEditingController pesantrenController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LoginBloc bloc;
  bool _isLoading = false;

  void loginListener(BuildContext context, LoginState state) async {
    if (state is LoginLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is LoginPesantrenLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is LoginSuccess) {
      setState(() {
        _isLoading = false;
        Get.offAll(DashboardScreen(widget.alice));
      });
    } else if (state is LoginPesantrenSuccess) {
      bloc.add(LoginStudent(nisController.text, passwordController.text));
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });

      MySnackbar(context).errorSnackbar(state.message);
    }
  }

  @override
  void initState() {
    bloc = BlocProvider.of<LoginBloc>(context);
    _getPesantren();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<LoginBloc, LoginState>(
      listener: loginListener,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: MyColors.primary,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
            ),
            elevation: 0,
            // leading: IconButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   icon: Icon(
            //     Icons.arrow_back_ios,
            //     color: MyColors.grey_60,
            //   ),
            // ),
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
                    Image.asset(
                      "assets/logo_esekolah.png",
                      height: 100,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Assalamu'alaikum, selamat datang di"),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _pesantrenLoginResponse?.namaPesantren ??
                              "ePesantren",
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TypeAheadFormField(
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
                      suggestionsCallback: (pattern) async {
                        return await _getKodePesantren();
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
                    const SizedBox(
                      height: 15,
                    ),
                    TypeAheadFormField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: nisController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            errorStyle: const TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                            hintText: 'NIS Santri',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      suggestionsCallback: (pattern) async {
                        return await _getKodeStudent();
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
                        if (suggestion != null) {
                          nisController.text = suggestion.toString();
                        }
                      },
                      validator: (value) {
                        // if (value.isEmpty) {
                        //   return 'Please select a city';
                        // }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
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
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          Get.to(const ForgotPassword());
                        },
                        child: const Text(
                          "Lupa password?",
                          style: TextStyle(
                            color: MyColors.primary,
                          ),
                          textAlign: TextAlign.end,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    _isLoading
                        ? ProgressLoading()
                        : ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        MyColors.primary),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0)))),
                            onPressed: () async {
                              print("gglang");
                              var nis = nisController.text;
                              var password = passwordController.text;
                              if (nis.isEmpty) {
                                MySnackbar(context)
                                    .errorSnackbar("NIS tidak boleh kosong");
                                return;
                              }
                              if (password.isEmpty) {
                                MySnackbar(context).errorSnackbar(
                                    "Password tidak boleh kosong");
                                return;
                              }
                              await saveKodeStudnet(nis);
                              await saveKodePesantren(pesantrenController.text);
                              bloc.add(
                                  LoginPesantren(pesantrenController.text));
                            },
                            child: Padding(
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
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                        },
                        child: const Center(
                            child: Text(
                          "Hapus riwayat",
                          style: TextStyle(color: MyColors.primary),
                        ))),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(child: Text("Butuh bantuan?")),
                    const SizedBox(
                      height: 5,
                    ),
                    const Center(
                        child: Text(
                      "Hubungi admin",
                      style: TextStyle(color: MyColors.primary),
                    )),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   fcmToken ?? "",
                    //   textAlign: TextAlign.center,
                    // ),
                  ],
                ),
              ),
            ),
          ])),
    );
  }
}
