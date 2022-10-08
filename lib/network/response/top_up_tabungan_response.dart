// To parse this JSON data, do
//
//     final topUpTabunganResponse = topUpTabunganResponseFromJson(jsonString);

import 'dart:convert';

TopUpTabunganResponse topUpTabunganResponseFromJson(String str) => TopUpTabunganResponse.fromJson(json.decode(str));

class TopUpTabunganResponse {
  TopUpTabunganResponse({
    this.isCorrect,
    this.kodeSekolah,
    this.nis,
    this.noref,
    this.noIpaymu,
    this.catatan,
    this.nominal,
    this.metode,
    this.message,
  });

  bool? isCorrect;
  String? kodeSekolah;
  String? nis;
  String? noref;
  int? noIpaymu;
  String? catatan;
  String? nominal;
  List<Metode>? metode;
  String? message;

  factory TopUpTabunganResponse.fromJson(Map<String, dynamic> json) => TopUpTabunganResponse(
    isCorrect: json["is_correct"],
    kodeSekolah: json["kode_sekolah"],
    nis: json["nis"],
    noref: json["noref"],
    noIpaymu: json["no_ipaymu"],
    catatan: json["catatan"],
    nominal: json["nominal"],
    metode: List<Metode>.from(json["metode"].map((x) => Metode.fromJson(x))),
    message: json["message"],
  );

}

class Metode {
  Metode({
    this.metodeBayar,
    this.detail,
  });

  String? metodeBayar;
  Detail? detail;

  factory Metode.fromJson(Map<String, dynamic> json) => Metode(
    metodeBayar: json["metode_bayar"],
    detail: Detail.fromJson(json["detail"]),
  );

}

class Detail {
  Detail({
    this.jenisBayar,
    this.metodeChannel,
    this.metodeBank,
    this.metodeBankLogo,
    this.kode,
    this.fee,
  });

  String? jenisBayar;
  String? metodeChannel;
  String? metodeBank;
  String? metodeBankLogo;
  String? kode;
  String? fee;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    jenisBayar: json["jenis_bayar"],
    metodeChannel: json["metode_channel"],
    metodeBank: json["metode_bank"],
    metodeBankLogo: json["metode_bank_logo"],
    kode: json["kode"],
    fee: json["fee"],
  );

  Map<String, dynamic> toJson() => {
    "jenis_bayar": jenisBayar,
    "metode_channel": metodeChannel,
    "metode_bank": metodeBank,
    "metode_bank_logo": metodeBankLogo,
    "kode": kode,
    "fee": fee,
  };
}
