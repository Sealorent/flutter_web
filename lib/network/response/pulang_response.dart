// To parse this JSON data, do
//
//     final pulangResponse = pulangResponseFromJson(jsonString);

import 'dart:convert';

PulangResponse pulangResponseFromJson(String str) => PulangResponse.fromJson(json.decode(str));

class PulangResponse {
  PulangResponse({
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

  factory PulangResponse.fromJson(Map<String, dynamic> json) => PulangResponse(
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
    this.tanggal,
    this.waktu,
    this.catatan,
    this.detail,
  });

  DateTime? tanggal;
  String? waktu;
  String? catatan;
  Detail? detail;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
    tanggal: DateTime.parse(json["tanggal"]),
    waktu: json["waktu"],
    catatan: json["catatan"],
    detail: Detail.fromJson(json["detail"]),
  );

}

class Detail {
  Detail({
    this.waktu,
    this.catatan,
    this.disetujui,
  });

  String? waktu;
  String? catatan;
  String? disetujui;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    waktu: json["waktu"],
    catatan: json["catatan"],
    disetujui: json["disetujui"],
  );

  Map<String, dynamic> toJson() => {
    "waktu": waktu,
    "catatan": catatan,
    "disetujui": disetujui,
  };
}
