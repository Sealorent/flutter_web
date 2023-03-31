// To parse this JSON data, do
//
//     final topUpTabunganResponse = topUpTabunganResponseFromJson(jsonString);

import 'dart:convert';

import 'package:pesantren_flutter/network/response/ringkasan_response.dart';

TopUpTabunganResponse topUpTabunganResponseFromJson(String str) => TopUpTabunganResponse.fromJson(json.decode(str));

class TopUpTabunganResponse {
  TopUpTabunganResponse({
    this.isCorrect,
    this.kodeSekolah,
    this.nis,
    this.nomor,
    this.period,
    this.noIpaymu,
    this.catatan,
    this.nominal,
    this.metode,
    this.message,
  });

  bool? isCorrect;
  String? kodeSekolah;
  String? nis;
  String? nomor;
  String? period;
  String? noIpaymu;
  String? catatan;
  String? nominal;
  List<Metode>? metode;
  String? message;

  factory TopUpTabunganResponse.fromJson(Map<String, dynamic> json) => TopUpTabunganResponse(
    isCorrect: json["is_correct"],
    kodeSekolah: json["kode_sekolah"],
    nis: json["nis"],
    nomor: json["nomor"],
    period: json["period"],
    noIpaymu: json["no_ipaymu"],
    catatan: json["catatan"],
    nominal: json["nominal"],
    metode: List<Metode>.from(json["metode"].map((x) => Metode.fromJson(x))),
    message: json["message"],
  );


}

class Metode {
  Metode({
    this.metode,
    this.bank,
    this.logo,
    this.kode,
    this.fee,
  });

  String? metode;
  String? bank;
  String? logo;
  String? kode;
  String? fee;

  factory Metode.fromJson(Map<String, dynamic> json) => Metode(
    metode: json["metode"],
    bank: json["bank"],
    logo: json["logo"],
    kode: json["kode"],
    fee: json["fee"],
  );

  Map<String, dynamic> toJson() => {
    "metode": metode,
    "bank": bank,
    "logo": logo,
    "kode": kode,
    "fee": fee,
  };

  Bayar toBayar() {
    return Bayar(
      metode: metode,
      bank: bank,
      logo: logo,
      kode: kode,
      fee: fee
    );
  }
}
