import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pesantren_flutter/network/response/pesantren_login_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/login/login_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/screen_utils.dart';
import '../../widget/progress_loading.dart';
import 'login_bloc.dart';
import 'login_state.dart';

class LoginUserScreen extends StatefulWidget {
  const LoginUserScreen({Key? key}) : super(key: key);

  @override
  State<LoginUserScreen> createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen> {

  Future<void> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren = pesantrenLoginResponseFromJson(pesantren ?? "");
    setState(() {
      _pesantrenLoginResponse = objectpesantren;
    });
  }

  PesantrenLoginResponse? _pesantrenLoginResponse;
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
    }else if (state is LoginPesantrenLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is LoginSuccess) {
      setState(() {
        _isLoading = false;
        ScreenUtils(context).navigateTo(DashboardScreen(null));
      });
    } else if (state is LoginPesantrenSuccess) {
      bloc.add(LoginStudent(nisController.text, passwordController.text));
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context)
            .errorSnackbar("Login gagal, silahkan login ulang");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
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
                        Text("Assalamu’alaikum, selamat datang"),
                        SizedBox(height: 10,),
                        Text(_pesantrenLoginResponse?.namaPesantren ?? "", style: TextStyle(fontSize: 22),),
                      ],
                    ),
                    SizedBox(height: 40,),
                    TextFormField(
                      controller: pesantrenController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Kode Pesantren',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: nisController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'NIS Santri',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: passwordController,
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
                    _isLoading ? ProgressLoading() : ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0)
                              )
                          )
                      ),
                      onPressed: () async {
                        var nis = nisController.text;
                        var password = passwordController.text;
                        if(nis.isEmpty){
                          MySnackbar(context).errorSnackbar("NIS tidak boleh kosong");
                          return;
                        }
                        if(password.isEmpty){
                          MySnackbar(context).errorSnackbar("Password tidak boleh kosong");
                          return;
                        }
                        bloc.add(LoginPesantren(pesantrenController.text));
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
          ])),
    );
  }
}
