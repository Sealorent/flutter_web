import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/response/information_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/home/home_bloc.dart';
import 'package:pesantren_flutter/ui/home/home_event.dart';
import 'package:pesantren_flutter/ui/home/home_state.dart';
import 'package:pesantren_flutter/ui/home/information/information_detail.dart';
import 'package:pesantren_flutter/ui/home/information/information_screen.dart';
import 'package:pesantren_flutter/ui/izin/izin_screen.dart';
import 'package:pesantren_flutter/ui/konseling/konseling_screen.dart';
import 'package:pesantren_flutter/ui/mudif/mudif_screen.dart';
import 'package:pesantren_flutter/ui/payment/main/payment_screen.dart';
import 'package:pesantren_flutter/ui/presensi/presensi_screen.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_screen.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_screen.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/response/pesantren_login_response.dart';
import '../../network/response/student_login_response.dart';
import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';
import '../../utils/screen_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late StudentLoginResponse _user;
  late PesantrenLoginResponse _pesantren;
  bool _isLoading = true;
  InformationResponse? _informationResponse;
  late HomeBloc bloc;

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.student);
    var objectStudent = StudentLoginResponse.fromJson(json.decode(student ?? ""));

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

  void listener(BuildContext context, HomeState state) async {
    if (state is GetInformationLoading) {
      setState(() {
        _isLoading = true;
      });
    } else if (state is GetInformationSuccess) {

      setState(() {
        _isLoading = false;
        _informationResponse = state.response;
      });
    } else if (state is FailedState) {
      setState(() {
        _isLoading = false;
      });
      if (state.code == 401 || state.code == 0) {
        MySnackbar(context)
            .errorSnackbar("Terjadi kesalahan");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  void _getData(){
    bloc.add(GetInformation());
  }

  @override
  void initState() {
    bloc = BlocProvider.of<HomeBloc>(context);
    _getData();
    _getUser();
    _getPesantren();
    super.initState();
  }

  List<Widget> buildInformations(){
    return _informationResponse?.informasi?.map((e) => Column(
      children: [
        SizedBox(height: 15,),
        InkWell(
          onTap: (){
            ScreenUtils(context).navigateTo(InformationDetailScreen(e));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c94b6),
                        image: DecorationImage(
                          image: NetworkImage(
                              e.detail?.image ?? ""),
                          fit: BoxFit.cover,
                        ),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.detail?.judulInfo ?? "", style: TextStyle( fontSize: 18),),
                          SizedBox(height: 8,),
                          Text(DateFormat('dd-MM-yyyy').format(e.tanggal ?? DateTime.now()), style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ],
    )).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<HomeBloc, HomeState>(
        listener: listener,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            _getData();
          },
          child: _isLoading ? ProgressLoading() : ListView(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    child: SvgPicture.asset("assets/background_mosque.svg",
                        fit: BoxFit.fill),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _pesantren.namaPesantren ?? "",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _user.nama ?? "",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  Text(
                                    _user.kelas ?? "",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        _user.photo ?? ""),
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(PaymentScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_bayar.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Bayar\n")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(SavingScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_tabungan.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Tabungan\n")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(TahfidzScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_tahfidz.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Tafidz\n")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(RekamMedisScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_rekam_medis.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Rekam\nMedis")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap : (){
                        ScreenUtils(context).navigateTo(KonselingScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_conseling.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Konseling")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap : (){
                        ScreenUtils(context).navigateTo(IzinScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_izin.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Izin")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(MudifScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_mudif.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Mudif")
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(PresensiScreen());
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset("assets/ic_presensi.svg", width: 50,),
                          SizedBox(height: 5,),
                          Text("Presensi")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text("Informasi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        ScreenUtils(context).navigateTo(InformationScreen());
                      },
                      child: Row(
                        children: [
                          Text("Lihat semua"),
                          SizedBox(width: 5,),
                          Icon(Icons.arrow_forward_ios, color: MyColors.grey_60, size: 20,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: buildInformations(),
              ),
              SizedBox(height: 100,)
            ],
          ),
        ),
      ),
    );
  }
}
