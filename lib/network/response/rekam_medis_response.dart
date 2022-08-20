// To parse this JSON data, do
//
//     final rekamMedisResponse = rekamMedisResponseFromJson(jsonString);

import 'dart:convert';

RekamMedisResponse rekamMedisResponseFromJson(String str) => RekamMedisResponse.fromJson(json.decode(str));
class RekamMedisResponse {
  RekamMedisResponse({
    this.isCorrect,
    this.username,
    this.nama,
    this.nis,
    this.phone,
    this.periodStart,
    this.periodEnd,
    this.majorsName,
    this.majorsSName,
    this.className,
    this.classId,
    this.laporan,
    this.message,
  });

  bool? isCorrect;
  String? username;
  String? nama;
  String? nis;
  String? phone;
  String? periodStart;
  String? periodEnd;
  String? majorsName;
  String? majorsSName;
  String? className;
  String? classId;
  List<Laporan>? laporan;
  String? message;

  factory RekamMedisResponse.fromJson(Map<String, dynamic> json) => RekamMedisResponse(
    isCorrect: json["is_correct"],
    username: json["username"],
    nama: json["nama"],
    nis: json["nis"],
    phone: json["phone"],
    periodStart: json["period_start"],
    periodEnd: json["period_end"],
    majorsName: json["majors_name"],
    majorsSName: json["majors_s_name"],
    className: json["class_name"],
    classId: json["class_id"],
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
    this.sakit,
    this.penanganan,
    this.catatan,
  });

  String? sakit;
  String? penanganan;
  String? catatan;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    sakit: json["sakit"],
    penanganan: json["penanganan"],
    catatan: json["catatan"],
  );

  Map<String, dynamic> toJson() => {
    "sakit": sakit,
    "penanganan": penanganan,
    "catatan": catatan,
  };
}
