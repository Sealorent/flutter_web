import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/model/year_model.dart';
import 'package:pesantren_flutter/network/response/presensi_response.dart';
import 'package:pesantren_flutter/network/response/rekam_medis_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/ui/payment/pay_bills_screen.dart';
import 'package:pesantren_flutter/ui/presensi/presensi_view.dart';
import 'package:pesantren_flutter/ui/presensi/presensi_pelajaran_view.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_bloc.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_event.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_state.dart';
import 'package:pesantren_flutter/ui/saving/saving_bloc.dart';

import 'package:pesantren_flutter/utils/number_utils.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pesantren_flutter/utils/year_util.dart';
import 'package:pesantren_flutter/widget/progress_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import '../../utils/my_snackbar.dart';
import '../transaction/model/item_filter_model.dart';

class PresensiScreen extends StatefulWidget {
  const PresensiScreen({Key? key}) : super(key: key);

  @override
  State<PresensiScreen> createState() => _PresensiScreenScreenState();
}

class _PresensiScreenScreenState extends State<PresensiScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
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
          title: Text(
            "Presensi",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: MyColors.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.white),
            tabs: [
              Tab(
                text: "Harian",
              ),
              Tab(
                text: "Pelajaran",
              ),
            ],
            indicatorColor: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
        body: const TabBarView(
          children: [PresensiView(), PresensiPelajaranView()],
        ),
      ),
    );
  }
}
