import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../../utils/screen_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
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
                          "Ponpes Al-Hikmah Gresik",
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
                                  "Mulya Lukman Lazuardi",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Text(
                                  "Kelas Prapersiapan Putra 1",
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
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_tabungan.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Tabungan\n")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_tahfidz.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Tafidz\n")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_rekam_medis.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Rekam\nMedis")
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_conseling.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Konseling")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_izin.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Izin")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_mudif.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Mudif")
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SvgPicture.asset("assets/ic_presensi.svg", width: 50,),
                      SizedBox(height: 5,),
                      Text("Presensi")
                    ],
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
            SizedBox(height: 15,),
            Padding(
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
                                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pesantren Update", style: TextStyle( fontSize: 18),),
                          SizedBox(height: 8,),
                          Text("Selasa, 8 Mar 2022", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
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
                                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pesantren Update", style: TextStyle( fontSize: 18),),
                          SizedBox(height: 8,),
                          Text("Selasa, 8 Mar 2022", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
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
                                'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                            fit: BoxFit.cover,
                          ),
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Pesantren Update", style: TextStyle( fontSize: 18),),
                          SizedBox(height: 8,),
                          Text("Selasa, 8 Mar 2022", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}
