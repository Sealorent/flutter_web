// To parse this JSON data, do
//
//     final settingResponse = settingResponseFromJson(jsonString);

import 'dart:convert';
import 'package:collection/collection.dart';
SettingResponse settingResponseFromJson(String str) => SettingResponse.fromJson(json.decode(str));

class SettingResponse {
  SettingResponse({
    this.isCorrect,
    this.laporan,
    this.message,
  });

  bool? isCorrect;
  List<Laporan>? laporan;
  String? message;

  String getWhatsapp(){
    return laporan?.firstWhereOrNull((element) => element.settingWhatsapp != null)?.settingWhatsapp ?? "";
  }

  String getTelegram(){
    return laporan?.firstWhereOrNull((element) => element.settingTelegram != null)?.settingTelegram ?? "";
  }

  String getInstagram(){
    var data= laporan?.firstWhereOrNull((element) => element.settingInstagram != null)?.settingInstagram ?? "";
    if(data.isEmpty) return data;
    else {
      return "https://instagram.com/$data";
    }
  }

  String getWeb(){
    return laporan?.firstWhereOrNull((element) => element.settingWebsite != null)?.settingWebsite ?? "";
  }

  String getFacebook(){
    var data= laporan?.firstWhereOrNull((element) => element.settingFacebook != null)?.settingFacebook ?? "";
    if(data.isEmpty) return data;
    else {
      return "https://facebook.com/$data";
    }
  }

  String getYoutube(){
    var data= laporan?.firstWhereOrNull((element) => element.settingYoutube != null)?.settingYoutube ?? "";
    if(data.isEmpty) return data;
    else {
      return "https://youtube.com/channel/$data";
    }
  }

  factory SettingResponse.fromJson(Map<String, dynamic> json) => SettingResponse(
    isCorrect: json["is_correct"],
    laporan: List<Laporan>.from(json["laporan"].map((x) => Laporan.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
    "laporan": List<dynamic>.from(laporan?.map((x) => x.toJson()) ?? []),
    "message": message,
  };

}

class Laporan {
  Laporan({
    this.settingAktivasi,
    this.settingEmail,
    this.settingWebsite,
    this.settingWhatsapp,
    this.settingFacebook,
    this.settingInstagram,
    this.settingYoutube,
    this.settingPackage,
    this.settingTelegram
  });

  String? settingAktivasi;
  String? settingEmail;
  String? settingWebsite;
  String? settingWhatsapp;
  String? settingFacebook;
  String? settingInstagram;
  String? settingYoutube;
  String? settingPackage;
  String? settingTelegram;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
    settingAktivasi: json["setting_aktivasi"] == null ? null : json["setting_aktivasi"],
    settingEmail: json["setting_email"] == null ? null : json["setting_email"],
    settingWebsite: json["setting_website"] == null ? null : json["setting_website"],
    settingWhatsapp: json["setting_whatsapp"] == null ? null : json["setting_whatsapp"],
    settingFacebook: json["setting_facebook"] == null ? null : json["setting_facebook"],
    settingInstagram: json["setting_instagram"] == null ? null : json["setting_instagram"],
    settingYoutube: json["setting_youtube"] == null ? null : json["setting_youtube"],
    settingPackage: json["setting_package"] == null ? null : json["setting_package"],
    settingTelegram: json["setting_telegram"] == null ? null : json["setting_telegram"],
  );

  Map<String, dynamic> toJson() => {
    "setting_aktivasi": settingAktivasi == null ? null : settingAktivasi,
    "setting_email": settingEmail == null ? null : settingEmail,
    "setting_website": settingWebsite == null ? null : settingWebsite,
    "setting_whatsapp": settingWhatsapp == null ? null : settingWhatsapp,
    "setting_facebook": settingFacebook == null ? null : settingFacebook,
    "setting_instagram": settingInstagram == null ? null : settingInstagram,
    "setting_youtube": settingYoutube == null ? null : settingYoutube,
    "setting_package": settingPackage == null ? null : settingPackage,
  };
}
