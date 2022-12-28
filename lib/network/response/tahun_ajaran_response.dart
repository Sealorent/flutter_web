// To parse this JSON data, do
//
//     final tahunAjaranResponse = tahunAjaranResponseFromJson(jsonString);

import 'dart:convert';

TahunAjaranResponse tahunAjaranResponseFromJson(String str) => TahunAjaranResponse.fromJson(json.decode(str));

class TahunAjaranResponse {
  TahunAjaranResponse({
    this.isCorrect,
    this.tahunajaran,
    this.message,
  });

  bool? isCorrect;
  List<Tahunajaran>? tahunajaran;
  String? message;

  factory TahunAjaranResponse.fromJson(Map<String, dynamic> json) => TahunAjaranResponse(
    isCorrect: json["is_correct"],
    tahunajaran: List<Tahunajaran>.from(json["tahunajaran"].map((x) => Tahunajaran.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
    "tahunajaran": List<dynamic>.from((tahunajaran ?? []).map((x) => x.toJson())),
    "message": message,
  };

}

class Tahunajaran {
  Tahunajaran({
    this.id,
    required this.periodStart,
    required this.periodEnd,
    this.periodStatus,
    this.isSelected = false
  });

  String? id;
  String? periodStart;
  String? periodEnd;
  String? periodStatus;
  bool isSelected;

  String getTitle(){
    return "$periodStart/$periodEnd";
  }

  int getStart(){
    return int.tryParse(periodStart ?? "0") ?? 0;
  }

  int getEnd(){
    return int.tryParse(periodEnd ?? "0") ?? 0;
  }

  factory Tahunajaran.fromJson(Map<String, dynamic> json) => Tahunajaran(
    id: json["id"],
    periodStart: json["period_start"],
    periodEnd: json["period_end"],
    periodStatus: json["period_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "period_start": periodStart,
    "period_end": periodEnd,
    "period_status": periodStatus,
  };
}
