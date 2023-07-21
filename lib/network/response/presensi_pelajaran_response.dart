// To parse this JSON data, do
//
//     final PresensiPelajaranResponse = PresensiPelajaranResponseFromJson(jsonString);

import 'dart:convert';

PresensiPelajaranResponse PresensiPelajaranResponseFromJson(String str) =>
    PresensiPelajaranResponse.fromJson(json.decode(str));

class PresensiPelajaranResponse {
  PresensiPelajaranResponse({
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

  factory PresensiPelajaranResponse.fromJson(Map<String, dynamic> json) =>
      PresensiPelajaranResponse(
        isCorrect: json["is_correct"],
        username: json["username"],
        nama: json["nama"],
        nis: json["nis"],
        laporan:
            List<Laporan>.from(json["laporan"].map((x) => Laporan.fromJson(x))),
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
  Detail({this.tanggal, this.kehadiran, this.pelajaran});

  DateTime? tanggal;
  String? kehadiran;
  String? pelajaran;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        tanggal: DateTime.parse(json["tanggal"]),
        kehadiran: json["kehadiran"],
        pelajaran: json["pelajaran"],
      );
}
