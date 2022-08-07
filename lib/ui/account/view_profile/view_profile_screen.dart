import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/account/edit_profile/edit_profile_screen.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/screen_utils.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {

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
        actions: [
          IconButton(
            onPressed: () {
              ScreenUtils(context).navigateTo(EditProfileScreen());
            },
            icon: Icon(
              Icons.edit,
              color: MyColors.grey_5,
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
        title: Text("Profil", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {

        },
        child: ListView(
          children: [
            SizedBox(height: 20,),
            Center(
              child: Container(
                width: 60,
                height: 60,
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
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                "Mulya Lukman Lazuardi",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Santri"),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("NIS", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("1362552", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("KELAS", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Prapersiapan Putera 1", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("UNIT", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Ponpes Al-Hikmah Gresik", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("MADIN", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Kamar 08", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 20,),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Pribadi"),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("TEMPAT TANGGAL LAHIR", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Kediri, 1 September 2001", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("JENIS KELAMIN", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Laki-laki", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("ALAMAT", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Jl. Talang Ujung 40D, Kec. Kembangan Selatan, Kota Jakarta Barat, DKI Jakarta", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 20,),
            Container(
              color: MyColors.grey_10,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("Data Keluarga"),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("NAMA AYAH", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Wadi Kuswoyo", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("NAMA IBU", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Gasti Prastuti", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("NO. WHATSAPP ORANG TUA", style: TextStyle(color: MyColors.grey_60),),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("+62 852 9061 9822", style: TextStyle(color: MyColors.grey_80, fontSize: 16),),
            ),


            SizedBox(height: 150,)
          ],
        ),
      ),
    );
  }
}
