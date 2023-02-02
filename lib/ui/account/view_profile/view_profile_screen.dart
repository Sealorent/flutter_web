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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/response/pesantren_login_response.dart';
import '../../../network/response/student_login_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/my_snackbar.dart';
import '../../../utils/screen_utils.dart';
import '../../login/login_bloc.dart';
import '../../login/login_state.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  late StudentLoginResponse _user;
  late PesantrenLoginResponse _pesantren;

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

  late LoginBloc bloc;
  bool _isLoading = false;

  void loginListener(BuildContext context, LoginState state) async {
    if (state is RefreshProfileLoading) {
      setState(() {
        print("client:loading");
        _isLoading = true;
      });
    } else if (state is RefreshProfileSuccess) {
      setState(() {
        _getUser();
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        // MySnackbar(context).errorSnackbar("Silahkan coba lagi");
        return;
      }

      // MySnackbar(context)
      //     .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  @override
  void initState() {
    bloc = BlocProvider.of<LoginBloc>(context);
    _getPesantren();
    _getUser();
    bloc.add(RefreshProfile());
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
          actions: [
            IconButton(
              onPressed: () {
                ScreenUtils(context).navigateTo(EditProfileScreen(),
                    listener: (code) {
                  bloc.add(RefreshProfile());
                });
              },
              icon: Icon(
                Icons.edit,
                color: MyColors.grey_5,
              ),
            )
          ],
          centerTitle: true,
          elevation: 0,
          title: Text(
            "Profil",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            _getPesantren();
            _getUser();
            bloc.add(RefreshProfile());
          },
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: NetworkImage(_user.photo ?? ""),
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
                height: 10,
              ),
              Center(
                child: Text(
                  _user.nama ?? "",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: MyColors.grey_10,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Data Santri"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "NIS",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.nis ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "KELAS",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.kelas ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "UNIT",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _pesantren.namaPesantren ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "MADIN",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.student_madin ?? "-",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: MyColors.grey_10,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Data Pribadi"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "TEMPAT TANGGAL LAHIR",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "${_user.tempatlahir ?? ""}, ${DateFormat("dd MMM yyyy").format(_user.tanggallahir ?? DateTime.now())}",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "JENIS KELAMIN",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.gender == "L" ? "Laki-laki" : "Perempuan",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "ALAMAT",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "-",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: MyColors.grey_10,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("Data Keluarga"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "NAMA AYAH",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.ayah ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "NAMA IBU",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.ibu ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "NO. WHATSAPP ORANG TUA",
                  style: TextStyle(color: MyColors.grey_60),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  _user.phone ?? "",
                  style: TextStyle(color: MyColors.grey_80, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 150,
              )
            ],
          ),
        ),
      ),
    );
  }
}
