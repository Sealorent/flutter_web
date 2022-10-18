import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pesantren_flutter/network/response/setting_response.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:pesantren_flutter/ui/dashboard/dashboard_screen.dart';
import 'package:pesantren_flutter/widget/social_media.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';
import '../../preferences/pref_data.dart';
import '../../utils/my_snackbar.dart';


class BantuanScreen extends StatefulWidget {
  const BantuanScreen({Key? key}) : super(key: key);

  @override
  State<BantuanScreen> createState() => _BantuanScreenState();
}

class _BantuanScreenState extends State<BantuanScreen> {

  SettingResponse? _settingResponse;

  Future<void> _getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.setting);
    var objectStudent = SettingResponse.fromJson(json.decode(student ?? ""));

    setState(() {
      _settingResponse = objectStudent;
    });
  }

  @override
  void initState() {
    super.initState();
    _getSetting();
  }

  _launchWhatsapp() async {
    var whatsapp = "+${_settingResponse?.getWhatsapp()}";
    if(_settingResponse?.getWhatsapp().isEmpty == true) {
      MySnackbar(context).errorSnackbar("Nomor whatsapp belum di setting.");
      return;
    }
      var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=");
      await launchUrl(whatsappAndroid);

  }

  _launchTelegram() async {
    String url = _settingResponse?.getTelegram() ?? "";
    if(url.isEmpty) {
      MySnackbar(context).errorSnackbar("Telegram belum di setting.");
      return;
    }
    var telegramAndroid =Uri.parse(url);
    await launchUrl(telegramAndroid, mode: LaunchMode.externalApplication);
  }


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
                    _launchWhatsapp();
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
                    _launchTelegram();
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
                SocialMedia(_settingResponse,context)
              ],
            ),
          ),


        ],
      ),
    );
  }
}
