// To parse this JSON data, do
//
//     final savingResponse = savingResponseFromJson(jsonString);

import 'dart:convert';
import 'package:collection/collection.dart';

SavingResponse savingResponseFromJson(String str) => SavingResponse.fromJson(json.decode(str));

class SavingResponse {
  SavingResponse({
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
    this.saldo,
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
  int? saldo;
  List<Laporan>? laporan;
  String? message;

  factory SavingResponse.fromJson(Map<String, dynamic> json) => SavingResponse(
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
    saldo: json["saldo"],
    laporan: List<Laporan>.from(json["laporan"].map((x) => Laporan.fromJson(x))),
    message: json["message"],
  );

  double getTotalCredit(){
    var ints = laporan?.map((e) => double.tryParse(e.detail?.kredit ?? "") ?? 0.0).toList() ?? [];
    return ints.sum;
  }

  double getTotalDebit(){
    var ints = laporan?.map((e) => double.tryParse(e.detail?.debit ?? "") ?? 0.0).toList() ?? [];
    return ints.sum;
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
    this.debit,
    this.kredit,
    this.catatan,
  });

  String? debit;
  String? kredit;
  String? catatan;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    debit: json["debit"],
    kredit: json["kredit"],
    catatan: json["catatan"],
  );

  Map<String, dynamic> toJson() => {
    "debit": debit,
    "kredit": kredit,
    "catatan": catatan,
  };
}
