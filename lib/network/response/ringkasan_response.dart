// To parse this JSON data, do
//
//     final ringkasanResponse = ringkasanResponseFromJson(jsonString);

import 'dart:convert';

RingkasanResponse ringkasanResponseFromJson(String str) =>
    RingkasanResponse.fromJson(json.decode(str));

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

  factory RingkasanResponse.fromJson(Map<String, dynamic> json) =>
      RingkasanResponse(
        isCorrect: json["is_correct"],
        noref: json["noref"],
        bulan: List<Beba>.from(json["bulan"].map((x) => Beba.fromJson(x))),
        bebas: List<Beba>.from(json["bebas"].map((x) => Beba.fromJson(x))),
        bayar: List<Bayar>.from(json["bayar"].map((x) => Bayar.fromJson(x))),
        message: json["message"],
      );
}

class Bayar {
  Bayar({this.metode, this.bank, this.logo, this.kode, this.fee});

  String? metode;
  String? bank;
  String? logo;
  String? kode;
  String? fee;

  factory Bayar.fromJson(Map<String, dynamic> json) => Bayar(
      metode: json["metode"],
      bank: json["bank"],
      logo: json["logo"],
      kode: json["kode"],
      fee: json["fee"]);
}

class Detail {
  Detail(
      {this.jenisBayar,
      this.metodeChannel,
      this.metodeBank,
      this.metodeBankLogo,
      this.kode,
      this.fee,
      this.metodeBayar});

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
      metodeBayar: metode);

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
  Beba({this.namaBayar, this.nominal, this.bebasId, this.bulanId});

  String? namaBayar;
  String? nominal;
  String? bulanId;
  String? bebasId;

  factory Beba.fromJson(Map<String, dynamic> json) => Beba(
        namaBayar: json["nama_bayar"],
        nominal: json["nominal"],
        bebasId: json["bebas_id"],
        bulanId: json["bulan_id"],
      );

  Map<String, dynamic> toJson() => {
        "nama_bayar": namaBayar,
        "nominal": nominal,
      };
}
