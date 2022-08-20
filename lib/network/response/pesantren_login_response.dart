// To parse this JSON data, do
//
//     final pesantrenLoginResponse = pesantrenLoginResponseFromJson(jsonString);

import 'dart:convert';

PesantrenLoginResponse pesantrenLoginResponseFromJson(String str) => PesantrenLoginResponse.fromJson(json.decode(str));

String pesantrenLoginResponseToJson(PesantrenLoginResponse data) => json.encode(data.toJson());

class PesantrenLoginResponse {
  PesantrenLoginResponse({
    this.isCorrect,
    this.kodeSekolah,
    this.namaPesantren,
    this.alamatPesantren,
    this.domain,
    this.logo,
    this.waktuIndonesia,
    this.db,
    this.message,
  });

  bool? isCorrect;
  String? kodeSekolah;
  String? namaPesantren;
  String? alamatPesantren;
  String? domain;
  String? logo;
  String? waktuIndonesia;
  String? db;
  String? message;

  factory PesantrenLoginResponse.fromJson(Map<String, dynamic> json) => PesantrenLoginResponse(
    isCorrect: json["is_correct"],
    kodeSekolah: json["kode_sekolah"],
    namaPesantren: json["nama_pesantren"],
    alamatPesantren: json["alamat_pesantren"],
    domain: json["domain"],
    logo: json["logo"],
    waktuIndonesia: json["waktu_indonesia"],
    db: json["db"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
    "kode_sekolah": kodeSekolah,
    "nama_pesantren": namaPesantren,
    "alamat_pesantren": alamatPesantren,
    "domain": domain,
    "logo": logo,
    "waktu_indonesia": waktuIndonesia,
    "db": db,
    "message": message,
  };
}
