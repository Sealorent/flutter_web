// To parse this JSON data, do
//
//     final paymentBebasResponse = paymentBebasResponseFromJson(jsonString);

import 'dart:convert';

PaymentBebasResponse paymentBebasResponseFromJson(String str) => PaymentBebasResponse.fromJson(json.decode(str));


class PaymentBebasResponse {
  PaymentBebasResponse({
    this.isCorrect,
    this.bayar,
    this.message,
  });

  bool? isCorrect;
  List<Bayar>? bayar;
  String? message;

  factory PaymentBebasResponse.fromJson(Map<String, dynamic> json) => PaymentBebasResponse(
    isCorrect: json["is_correct"],
    bayar: List<Bayar>.from(json["bayar"].map((x) => Bayar.fromJson(x))),
    message: json["message"],
  );
}

class Bayar {
  Bayar({
    this.detailBebas,
  });

  DetailBebas? detailBebas;

  factory Bayar.fromJson(Map<String, dynamic> json) => Bayar(
    detailBebas: DetailBebas.fromJson(json["detail_bebas"]),
  );
}

class DetailBebas {
  DetailBebas({
    this.namaBayar,
    this.periodStart,
    this.periodEnd,
    this.bebasBill,
    this.bebasTotalPay,
  });

  String? namaBayar;
  String? periodStart;
  String? periodEnd;
  String? bebasBill;
  String? bebasTotalPay;

  factory DetailBebas.fromJson(Map<String, dynamic> json) => DetailBebas(
    namaBayar: json["nama_bayar"],
    periodStart: json["period_start"],
    periodEnd: json["period_end"],
    bebasBill: json["bebas_bill"],
    bebasTotalPay: json["bebas_total_pay"],
  );

  Map<String, dynamic> toJson() => {
    "nama_bayar": namaBayar,
    "period_start": periodStart,
    "period_end": periodEnd,
    "bebas_bill": bebasBill,
    "bebas_total_pay": bebasTotalPay,
  };
}
