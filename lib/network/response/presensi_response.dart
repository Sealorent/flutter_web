// To parse this JSON data, do
//
//     final presensiResponse = presensiResponseFromJson(jsonString);

import 'dart:convert';

PresensiResponse presensiResponseFromJson(String str) => PresensiResponse.fromJson(json.decode(str));

class PresensiResponse {
  PresensiResponse({
    this.isCorrect,
    this.username,
    this.nama,
    this.nis,
    this.laporan,
    this.message,
  });

  bool? isCorrect;
  String? username;
  String? nama;
  String? nis;
  List<Laporan>? laporan;
  String? message;

  factory PresensiResponse.fromJson(Map<String, dynamic> json) => PresensiResponse(
    isCorrect: json["is_correct"],
    username: json["username"],
    nama: json["nama"],
    nis: json["nis"],
    laporan: List<Laporan>.from(json["laporan"].map((x) => Laporan.fromJson(x))),
    message: json["message"],
  );
}

class Laporan {
  Laporan({
    this.detail,
  });

  Detail? detail;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
    detail: Detail.fromJson(json["detail"]),
  );

}

class Detail {
  Detail({
    this.tanggal,
    this.kehadiran,
  });

  DateTime? tanggal;
  String? kehadiran;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    tanggal: DateTime.parse(json["tanggal"]),
    kehadiran: json["kehadiran"],
  );

}
