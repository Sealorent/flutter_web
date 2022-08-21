import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/widget/social_media.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BantuanScreen extends StatefulWidget {
  const BantuanScreen({Key? key}) : super(key: key);

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        elevation: 0,
        title: Text("Bantuan", style: TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text("Butuh bantuan? Hubungi admin E-Pesantren di :"))
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                        color: Color(0xff25D366),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/ic_whatsapp.svg"),
                        SizedBox(width: 20,),
                        Text("Whatsapp",style: TextStyle(color: Colors.white),),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_right_sharp,color: Colors.white,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                        color: Color(0xff0088CC),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/ic_telegram.svg"),
                        SizedBox(width: 20,),
                        Text("Telegram",style: TextStyle(color: Colors.white),),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_right_sharp,color: Colors.white,)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SocialMedia()
              ],
            ),
          ),
          

        ],
      ),
    );
  }
}
