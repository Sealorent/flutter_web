// To parse this JSON data, do
//
//     final historyResponse = historyResponseFromJson(jsonString);

import 'dart:convert';

HistoryResponse historyResponseFromJson(String str) => HistoryResponse.fromJson(json.decode(str));

class HistoryResponse {
  HistoryResponse({
    this.isCorrect,
    this.nis,
    this.laporan,
    this.message,
  });

  bool? isCorrect;
  String? nis;
  List<Laporan>? laporan;
  String? message;

  factory HistoryResponse.fromJson(Map<String, dynamic> json) => HistoryResponse(
    isCorrect: json["is_correct"],
    nis: json["nis"],
    laporan: List<Laporan>.from(json["laporan"].map((x) => Laporan.fromJson(x))),
    message: json["message"],
  );

}

class Laporan {
  Laporan({
    this.noref,
    this.detail,
  });

  String? noref;
  Detail? detail;

  factory Laporan.fromJson(Map<String, dynamic> json) => Laporan(
    noref: json["noref"],
    detail: Detail.fromJson(json["detail"]),
  );

}

class Detail {
  Detail({
    this.tanggal,
    this.nominal,
    this.bayarVia,
  });

  String? tanggal;
  String? nominal;
  String? bayarVia;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    tanggal: json["tanggal"],
    nominal: json["nominal"],
    bayarVia: json["bayar_via"],
  );

}

