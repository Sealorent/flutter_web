
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pesantren_flutter/utils/my_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../network/response/setting_response.dart';

class SocialMedia extends StatelessWidget {
  SettingResponse? _settingResponse;
  BuildContext context;

  SocialMedia(this._settingResponse,this.context);

  _launchWeb() async {
    String url =
        _settingResponse?.getWeb() ?? "";
    if(url.isEmpty) MySnackbar(context).errorSnackbar("Url web belum di setting.");
    var telegramAndroid =Uri.parse(url);
    await launchUrl(telegramAndroid);
  }

  _launchFb() async {
    String url =
        _settingResponse?.getFacebook() ?? "";
    if(url.isEmpty) MySnackbar(context).errorSnackbar("Url facebook belum di setting.");
    var telegramAndroid =Uri.parse(url);
    await launchUrl(telegramAndroid);
  }

  _launchInsta() async {
    String url =
        _settingResponse?.getInstagram() ?? "";
    if(url.isEmpty) MySnackbar(context).errorSnackbar("Url instagram belum di setting.");
    var telegramAndroid =Uri.parse(url);
    await launchUrl(telegramAndroid);
  }

  _launchYoutube() async {
    String url =
        _settingResponse?.getYoutube() ?? "";
    if(url.isEmpty) MySnackbar(context).errorSnackbar("Url youtube belum di setting.");
    var telegramAndroid =Uri.parse(url);
    await launchUrl(telegramAndroid);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: (){
              _launchWeb();
            },
            child: SvgPicture.asset("assets/ic_web.svg")),
        SizedBox(width: 10,),
        InkWell(
            onTap: (){
              _launchFb();
            },
            child: SvgPicture.asset("assets/ic_facebook.svg")),
        SizedBox(width: 10,),
        InkWell(
            onTap: (){
              _launchInsta();
            },
            child: SvgPicture.asset("assets/ic_instagram.svg")),
        SizedBox(width: 10,),
        InkWell(
            onTap: (){
              _launchYoutube();
            },
            child: SvgPicture.asset("assets/ic_youtube.svg")),

      ],
    );
  }
}
