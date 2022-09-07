import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/edit_profile/edit_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/response/pesantren_login_response.dart';
import '../../../network/response/student_login_response.dart';
import '../../../preferences/pref_data.dart';
import '../../../utils/screen_utils.dart';

class TranscationDetailScreen extends StatefulWidget {
  const TranscationDetailScreen({Key? key}) : super(key: key);

  @override
  State<TranscationDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TranscationDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
        title: Text("Detail Transaksi", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.money),
                      SizedBox(width: 20,),
                      Text("Bayar Tagihan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 30,),
                  Text("STATUS", style: TextStyle(fontSize: 12),),
                  SizedBox(height: 5,),
                  Text("Menunggu Pembayaran", style: TextStyle(color: Colors.red),),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MyColors.grey_60),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      child: Center(
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("BCA Virtual Account", style: TextStyle(fontSize: 16),),
                                Text("Bayar sebelum 23 Apr, 15:00")
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios_sharp, color: MyColors.grey_60,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("TANGGAL TRANSAKSI", style: TextStyle(fontSize: 12),),
                  SizedBox(height: 5,),
                  Text("22 Apr 2022, 15:00", style: TextStyle(fontSize: 16),),
                  SizedBox(height: 20,),
                  Text("NO. REF", style: TextStyle(fontSize: 12),),
                  SizedBox(height: 5,),
                  Text("SP10621002512072201", style: TextStyle(fontSize: 16),),
                  SizedBox(height: 30,),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              color: MyColors.grey_5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("RINCIAN PEMBAYARAN"),
              ),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("Item (3)",  style: TextStyle(fontSize: 12)),
                      Spacer(),
                      Text("Jumlah", style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("SPP April 2022",  style: TextStyle(fontSize: 16)),
                      Spacer(),
                      Text("Rp125.00", style: TextStyle(fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("SPP April 2022",  style: TextStyle(fontSize: 16)),
                      Spacer(),
                      Text("Rp125.00", style: TextStyle(fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Divider(),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Text("TOTAL",  style: TextStyle(fontSize: 12)),
                      Spacer(),
                      Text("Rp125.000", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),)
                    ],
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
