import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/izin/izin_pulang_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tree_view/tree_view.dart';

import 'izin_keluar_screen.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({Key? key}) : super(key: key);

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> with TickerProviderStateMixin {


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
          title: Text("Izin", style: TextStyle(color: Colors.white),),
          bottom: const TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.green,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),),
                color: Colors.white),
            tabs: [
              Tab(text: "Keluar",),
              Tab(text: "Pulang",),
            ],
            indicatorColor: Color(0xffBDE3D7),
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            IzinKeluarScreen(),
            IzinPulangScreen()
          ],
        ),
      ),
    );
  }
}
