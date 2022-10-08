import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/edit_profile/edit_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/login/login_event.dart';
import 'package:pesantren_flutter/ui/login/login_state.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/response/pesantren_login_response.dart';
import '../../../network/response/student_login_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/my_snackbar.dart';
import '../../../utils/screen_utils.dart';
import '../../login/login_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordController2 = TextEditingController();

  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;
  bool _passwordVisible3 = false;


  late LoginBloc bloc;
  bool _isLoading = false;

  void loginListener(BuildContext context, LoginState state) async {
    if (state is ChangePasswordLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is ChangePasswordSuccess) {
      setState(() {
        _isLoading = false;
        Navigator.pop(context);
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context).errorSnackbar("Gagal mengganti password");
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
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: MyColors.grey_5,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          title: Text("Ganti Password", style: TextStyle(color: Colors.white),),
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
                child: TextFormField(
                  controller: _oldPasswordController,
                  obscureText: !_passwordVisible1,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: MyColors.primary,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(
                              () {
                                _passwordVisible1 = !_passwordVisible1;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: newPasswordController,
                  obscureText: !_passwordVisible2,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: MyColors.primary,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(
                              () {
                            _passwordVisible2 = !_passwordVisible2;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: newPasswordController2,
                  obscureText: !_passwordVisible3,
                  decoration: InputDecoration(
                    labelText: 'Ulangi Password Baru',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible3
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: MyColors.primary,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(
                              () {
                            _passwordVisible3 = !_passwordVisible3;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
        bottomSheet: _isLoading ? ProgressLoading() : Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)
                    )
                )
            ),
            onPressed: () async{

              var oldPass = _oldPasswordController.text.trim();
              var newPass = newPasswordController.text.trim();
              var confirm = newPasswordController2.text.trim();


              if(newPass != confirm){
                MySnackbar(context).errorSnackbar("Konfirmasi password tidak sama");
                return;
              }

              bloc.add(
                ChangePassword(oldPass, newPass, confirm)
              );

            },
            child:  Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Simpan",
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
      ),
    );
  }
}
