// To parse this JSON data, do
//
//     final informationResponse = informationResponseFromJson(jsonString);

import 'dart:convert';

InformationResponse informationResponseFromJson(String str) => InformationResponse.fromJson(json.decode(str));

class InformationResponse {
  InformationResponse({
    this.isCorrect,
    this.message,
    this.informasi,
  });

  bool? isCorrect;
  String? message;
  List<Informasi>? informasi;

  factory InformationResponse.fromJson(Map<String, dynamic> json) => InformationResponse(
    isCorrect: json["is_correct"],
    message: json["message"],
    informasi: List<Informasi>.from(json["informasi"].map((x) => Informasi.fromJson(x))),
  );

}

class Informasi {
  Informasi({
    this.tanggal,
    this.judulInfo,
    this.foto,
  });

  DateTime? tanggal;
  String? judulInfo;
  String? foto;

  factory Informasi.fromJson(Map<String, dynamic> json) => Informasi(
    tanggal: DateTime.parse(json["tanggal"]),
    judulInfo: json["judul_info"],
    foto: json["foto"],
  );


}
