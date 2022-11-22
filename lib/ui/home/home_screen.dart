import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/response/information_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/home/home_bloc.dart';
import 'package:pesantren_flutter/ui/home/home_event.dart';
import 'package:pesantren_flutter/ui/home/home_state.dart';
import 'package:pesantren_flutter/ui/home/information/information_detail.dart';
import 'package:pesantren_flutter/ui/home/information/information_screen.dart';
import 'package:pesantren_flutter/ui/izin/izin_screen.dart';
import 'package:pesantren_flutter/ui/konfirmasi/controller_konfirmasi.dart';
import 'package:pesantren_flutter/ui/konfirmasi/konfirmasi.dart';
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
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudentLoginResponse? _user;
  PesantrenLoginResponse? _pesantren;
  bool _isLoading = true;
  InformationResponse? _informationResponse;
  late HomeBloc bloc;

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
        // MySnackbar(context)
        //     .errorSnackbar("Terjadi kesalahan");
        return;
      }

      MySnackbar(context)
          .errorSnackbar(state.message + " : " + state.code.toString());
    }
  }

  void _getData() {
    bloc.add(GetInformation());
  }

  @override
  void initState() {
    bloc = BlocProvider.of<HomeBloc>(context);
    _getData();
    _getUser();
    _getPesantren();
    Get.put(KonfirmasiController());
    super.initState();
  }

  List<Widget> buildInformations() {
    return _informationResponse?.informasi?.take(3).map((e) {
          return InkWell(
            onTap: () {
              ScreenUtils(context).navigateTo(InformationDetailScreen(e));
            },
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: NetworkImage(e.foto ?? ""),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          );
        }).toList() ??
        [];
  }

  void _otherBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (builder) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Lainnya"),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            ScreenUtils(context).navigateTo(PresensiScreen());
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                "assets/ic_presensi.svg",
                                width: 50,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Presensi")
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GetBuilder<KonfirmasiController>(
                            initState: (state) =>
                                KonfirmasiController.to.getKonfirmasi(),
                            builder: (_) {
                              return InkWell(
                                  onTap: () {
                                    _.getKonfirmasi();
                                    Get.to(const Konfirmasi());
                                  },
                                  child: SizedBox(
                                    width: 95,
                                    child: Column(children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/ic_tabungan.svg",
                                            width: 50,
                                            color: MyColors.primary
                                                .withOpacity(0.1),
                                          ),
                                          const Icon(
                                            Icons.account_balance,
                                            color: Colors.green,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text('Konfirmasi')
                                    ]),
                                  ));
                            }),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
          child: _isLoading
              ? ProgressLoading()
              : ListView(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: size.width,
                          child: SvgPicture.asset(
                              "assets/background_mosque.svg",
                              fit: BoxFit.fill),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _pesantren?.namaPesantren ?? "",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _user?.nama ?? "",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          Text(
                                            _user?.kelas ?? "",
                                            style: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: DecorationImage(
                                          image:
                                              NetworkImage(_user?.photo ?? ""),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
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
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScreenUtils(context).navigateTo(PaymentScreen());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_bayar.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Bayar\n")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScreenUtils(context).navigateTo(SavingScreen());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_tabungan.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Tabungan\n")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScreenUtils(context).navigateTo(TahfidzScreen());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_tahfidz.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Tafidz\n")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_rekam_medis.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Rekam\nMedis")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScreenUtils(context)
                                  .navigateTo(KonselingScreen());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_conseling.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Konseling")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScreenUtils(context).navigateTo(IzinScreen());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_izin.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Izin")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              ScreenUtils(context).navigateTo(MudifScreen());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/ic_mudif.svg",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Mudif")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              _otherBottomSheetMenu();
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.more_horiz,
                                  size: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Lainnya")
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Informasi",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              ScreenUtils(context)
                                  .navigateTo(InformationScreen());
                            },
                            child: Row(
                              children: [
                                Text("Lihat semua"),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: MyColors.grey_60,
                                  size: 20,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarouselSlider(
                        items: buildInformations(),
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          reverse: true,
                          autoPlay: true,
                          autoPlayAnimationDuration: const Duration(seconds: 1),
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          ScreenUtils(context).navigateTo(InformationScreen());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text("Lihat semua"),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
