// To parse this JSON data, do
//
//     final caraPembayaranResponse = caraPembayaranResponseFromJson(jsonString);

import 'dart:convert';

CaraPembayaranResponse caraPembayaranResponseFromJson(String str) => CaraPembayaranResponse.fromJson(json.decode(str));

String caraPembayaranResponseToJson(CaraPembayaranResponse data) => json.encode(data.toJson());

class CaraPembayaranResponse {
  CaraPembayaranResponse({
    this.isCorrect,
    this.bayarVia,
    this.bank,
    this.label,
    this.va,
    this.payment,
    this.expired,
    this.message,
  });

  bool? isCorrect;
  String? bayarVia;
  String? bank;
  String? label;
  String? va;
  String? payment;
  String? expired;
  String? message;

  factory CaraPembayaranResponse.fromJson(Map<String, dynamic> json) => CaraPembayaranResponse(
    isCorrect: json["is_correct"],
    bayarVia: json["bayar_via"],
    bank: json["bank"],
    label: json["label"],
    va: json["va"],
    payment: json["payment"],
    expired: json["expired"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
    "bayar_via": bayarVia,
    "bank": bank,
    "label": label,
    "va": va,
    "payment": payment,
    "expired": expired,
    "message": message,
  };
}
