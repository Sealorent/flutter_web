import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/network/response/information_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/home/home_bloc.dart';
import 'package:pesantren_flutter/ui/home/home_event.dart';
import 'package:pesantren_flutter/ui/home/home_state.dart';
import 'package:pesantren_flutter/ui/konseling/konseling_screen.dart';
import 'package:pesantren_flutter/ui/payment/main/payment_screen.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_screen.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_screen.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/my_snackbar.dart';

class InformationDetailScreen extends StatefulWidget {

  Informasi? informationResponse;

  InformationDetailScreen(this.informationResponse, {Key? key}) : super(key: key);

  @override
  State<InformationDetailScreen> createState() => _InformationDetailScreenState();
}

class _InformationDetailScreenState extends State<InformationDetailScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: MyColors.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.share, color: Colors.black54,))
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xff7c94b6),
                image: DecorationImage(
                  image: NetworkImage(
                      widget.informationResponse?.detail?.image ?? ""),
                  fit: BoxFit.cover,
                ),
                borderRadius:
                BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.informationResponse?.detail?.judulInfo ?? "", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(DateFormat("EEEE, dd MMM yyyy").format(widget.informationResponse?.tanggal ?? DateTime.now()) ?? "", style: TextStyle(color: Colors.black54),),
                SizedBox(height: 5,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Html(
              data: widget.informationResponse?.detail?.detailInfo ?? "",
            ),
          ),
        ],
      ),
    );
  }
}
