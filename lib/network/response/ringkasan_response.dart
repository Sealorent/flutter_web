// To parse this JSON data, do
//
//     final ringkasanResponse = ringkasanResponseFromJson(jsonString);

import 'dart:convert';

RingkasanResponse ringkasanResponseFromJson(String str) => RingkasanResponse.fromJson(json.decode(str));

class RingkasanResponse {
  RingkasanResponse({
    this.isCorrect,
    this.noref,
    this.bulan,
    this.bebas,
    this.bayar,
    this.message,
  });

  bool? isCorrect;
  String? noref;
  List<Beba>? bulan;
  List<Beba>? bebas;
  List<Bayar>? bayar;
  String? message;

  factory RingkasanResponse.fromJson(Map<String, dynamic> json) => RingkasanResponse(
    isCorrect: json["is_correct"],
    noref: json["noref"],
    bulan: List<Beba>.from(json["bulan"].map((x) => Beba.fromJson(x))),
    bebas: List<Beba>.from(json["bebas"].map((x) => Beba.fromJson(x))),
    bayar: List<Bayar>.from(json["bayar"].map((x) => Bayar.fromJson(x))),
    message: json["message"],
  );

}

class Bayar {
  Bayar({
    this.metodeBayar,
    this.detail,
  });

  String? metodeBayar;
  Detail? detail;

  factory Bayar.fromJson(Map<String, dynamic> json) => Bayar(
    metodeBayar: json["metode_bayar"],
    detail: Detail.fromJson(json["detail"],json["metode_bayar"]),
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
    this.metodeBayar
  });

  String? jenisBayar;
  String? metodeChannel;
  String? metodeBank;
  String? metodeBankLogo;
  String? kode;
  String? fee;
  String? metodeBayar;

  factory Detail.fromJson(Map<String, dynamic> json, String? metode) => Detail(
    jenisBayar: json["jenis_bayar"],
    metodeChannel: json["metode_channel"],
    metodeBank: json["metode_bank"],
    metodeBankLogo: json["metode_bank_logo"],
    kode: json["kode"],
    fee: json["fee"],
    metodeBayar : metode
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

class Beba {
  Beba({
    this.namaBayar,
    this.nominal,
  });

  String? namaBayar;
  String? nominal;

  factory Beba.fromJson(Map<String, dynamic> json) => Beba(
    namaBayar: json["nama_bayar"],
    nominal: json["nominal"],
  );

  Map<String, dynamic> toJson() => {
    "nama_bayar": namaBayar,
    "nominal": nominal,
  };
}
