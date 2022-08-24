// To parse this JSON data, do
//
//     final mudifResponse = mudifResponseFromJson(jsonString);

import 'dart:convert';

MudifResponse mudifResponseFromJson(String str) => MudifResponse.fromJson(json.decode(str));


class MudifResponse {
  MudifResponse({
    this.isCorrect,
    this.detail,
    this.message,
  });

  bool? isCorrect;
  List<Detail>? detail;
  String? message;

  factory MudifResponse.fromJson(Map<String, dynamic> json) => MudifResponse(
    isCorrect: json["is_correct"],
    detail: List<Detail>.from(json["Detail"].map((x) => Detail.fromJson(x))),
    message: json["message"],
  );

}

class Detail {
  Detail({
    this.detail,
  });

  DetailClass? detail;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    detail: DetailClass.fromJson(json["detail"]),
  );

}

class DetailClass {
  DetailClass({
    this.tanggal,
    this.jam,
    this.pengunjung,
  });

  DateTime? tanggal;
  String? jam;
  String? pengunjung;

  factory DetailClass.fromJson(Map<String, dynamic> json) => DetailClass(
    tanggal: DateTime.parse(json["Tanggal"]),
    jam: json["Jam"],
    pengunjung: json["Pengunjung"],
  );

}
