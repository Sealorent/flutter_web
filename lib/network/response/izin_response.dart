// To parse this JSON data, do
//
//     final izinResponse = izinResponseFromJson(jsonString);

import 'dart:convert';

IzinResponse izinResponseFromJson(String str) => IzinResponse.fromJson(json.decode(str));

class IzinResponse {
  IzinResponse({
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

  factory IzinResponse.fromJson(Map<String, dynamic> json) => IzinResponse(
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
    this.detail,
  });

  DateTime? tanggal;
  Detail? detail;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
    tanggal: DateTime.parse(json["tanggal"]),
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
    catatan: json["note"],
    disetujui: json["disetujui"],
  );

  Map<String, dynamic> toJson() => {
    "waktu": waktu,
    "catatan": catatan,
    "disetujui": disetujui,
  };
}
