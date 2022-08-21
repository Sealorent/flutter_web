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
import 'package:pesantren_flutter/ui/konseling/konseling_screen.dart';
import 'package:pesantren_flutter/ui/payment/main/payment_screen.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_screen.dart';
import 'package:pesantren_flutter/ui/saving/saving_screen.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_screen.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/my_snackbar.dart';
import '../../../utils/screen_utils.dart';
import 'information_detail.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {

  bool _isLoading = true;
  InformationResponse? _informationResponse;
  late HomeBloc bloc;

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
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          title: Text("Semua Informasi", style: TextStyle(color: Colors.white),),
        ),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            _getData();
          },
          child: _isLoading ? ProgressLoading() : RefreshIndicator(
            onRefresh: ()async{
              _getData();
            },
            child: ListView(
              children: [
                Column(
                  children: buildInformations(),
                ),
                SizedBox(height: 100,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
