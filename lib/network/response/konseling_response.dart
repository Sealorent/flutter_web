// To parse this JSON data, do
//
//     final konselingResponse = konselingResponseFromJson(jsonString);

import 'dart:convert';
import 'package:collection/collection.dart';

import '../../model/year_model.dart';
KonselingResponse konselingResponseFromJson(String str) => KonselingResponse.fromJson(json.decode(str));

class KonselingResponse {
  KonselingResponse({
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

  factory KonselingResponse.fromJson(Map<String, dynamic> json) => KonselingResponse(
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


  int getTotalPelanggaran(YearModel? selectedYear){
    var tot = laporan?.where((element) {
      var date = element.tanggal;
      if(selectedYear != null && date != null){
        return date.isAfter(selectedYear.startYear) && date.isBefore(selectedYear.endYear);
      }else{
        return true;
      }
    }).map((e) => int.tryParse(e.detail?.poin ?? "0") ?? 0).toList() ?? [];
    return tot.sum;
  }
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
    this.pelanggaran,
    this.penanganan,
    this.poin,
    this.catatan,
  });

  String? pelanggaran;
  String? penanganan;
  String? poin;
  String? catatan;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    pelanggaran: json["pelanggaran"],
    penanganan: json["penanganan"],
    poin: json["poin"],
    catatan: json["catatan"],
  );

  Map<String, dynamic> toJson() => {
    "pelanggaran": pelanggaran,
    "penanganan": penanganan,
    "poin": poin,
    "catatan": catatan,
  };
}
