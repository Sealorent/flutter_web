// To parse this JSON data, do
//
//     final caraPembayaranResponse = caraPembayaranResponseFromJson(jsonString);

import 'dart:convert';

CaraPembayaranResponse caraPembayaranResponseFromJson(String str) =>
    CaraPembayaranResponse.fromJson(json.decode(str));

String caraPembayaranResponseToJson(CaraPembayaranResponse data) =>
    json.encode(data.toJson());

class CaraPembayaranResponse {
  CaraPembayaranResponse(
      {this.isCorrect,
      this.bayarVia,
      this.bank,
      this.label,
      this.va,
      this.nominal,
      this.payment,
      this.expired,
      this.message,
      this.carabayar});

  bool? isCorrect;
  String? bayarVia;
  String? bank;
  String? label;
  String? va;
  String? nominal;
  String? payment;
  String? expired;
  String? message;
  List<Carabayar>? carabayar;

  factory CaraPembayaranResponse.fromJson(Map<String, dynamic> json) =>
      CaraPembayaranResponse(
        isCorrect: json["is_correct"],
        bayarVia: json["bayar_via"],
        bank: json["bank"],
        label: json["label"],
        va: json["va"],
        nominal: json["nominal"],
        payment: json["payment"],
        expired: json["expired"],
        message: json["message"],
        carabayar: List<Carabayar>.from(
            json["carabayar"].map((x) => Carabayar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is_correct": isCorrect,
        "bayar_via": bayarVia,
        "bank": bank,
        "label": label,
        "va": va,
        "nominal": nominal,
        "payment": payment,
        "expired": expired,
        "message": message,
      };
}

class Carabayar {
  Carabayar({
    this.metode,
    this.bayar,
  });

  String? metode;
  String? bayar;

  factory Carabayar.fromJson(Map<String, dynamic> json) => Carabayar(
        metode: json["metode"],
        bayar: json["bayar"],
      );

  Map<String, dynamic> toJson() => {
        "metode": metode,
        "bayar": bayar,
      };
}
