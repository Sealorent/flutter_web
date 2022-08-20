// To parse this JSON data, do
//
//     final tahfidzResponse = tahfidzResponseFromJson(jsonString);

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:pesantren_flutter/model/year_model.dart';
TahfidzResponse tahfidzResponseFromJson(String str) => TahfidzResponse.fromJson(json.decode(str));


class TahfidzResponse {
  TahfidzResponse({
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

  factory TahfidzResponse.fromJson(Map<String, dynamic> json) => TahfidzResponse(
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

  int getTotalHafalan(YearModel? selectedYear){
    var total = laporan?.where((element) {
      var date = element.tanggal;
      if(selectedYear != null && date != null){
        return date.isAfter(selectedYear.startYear) && date.isBefore(selectedYear.endYear);
      }else{
        return true;
      }
    }).map((e) => int.tryParse(e.detail?.jumlahHafalanBaru ?? "") ?? 0).toList() ?? [];
    return total.sum;
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
    this.jumlahHafalanBaru,
    this.keteranganHafalanBaru,
    this.murojaah,
    this.murojaahHafalanBaru,
  });

  String? jumlahHafalanBaru;
  String? keteranganHafalanBaru;
  String? murojaah;
  String? murojaahHafalanBaru;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    jumlahHafalanBaru: json["jumlah_hafalan_baru"],
    keteranganHafalanBaru: json["keterangan_hafalan_baru"],
    murojaah: json["murojaah"],
    murojaahHafalanBaru: json["murojaah_hafalan_baru"],
  );

  Map<String, dynamic> toJson() => {
    "jumlah_hafalan_baru": jumlahHafalanBaru,
    "keterangan_hafalan_baru": keteranganHafalanBaru,
    "murojaah": murojaah,
    "murojaah_hafalan_baru": murojaahHafalanBaru,
  };
}
