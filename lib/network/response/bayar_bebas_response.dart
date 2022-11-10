// To parse this JSON data, do
//
//     final bayarBebasResponse = bayarBebasResponseFromJson(jsonString);

import 'dart:convert';

BayarBebasResponse bayarBebasResponseFromJson(String str) => BayarBebasResponse.fromJson(json.decode(str));

class BayarBebasResponse {
  BayarBebasResponse({
    this.isCorrect,
    this.pembayaran,
    this.detail,
    this.message,
  });

  bool? isCorrect;
  String? pembayaran;
  List<Detail>? detail;
  String? message;

  factory BayarBebasResponse.fromJson(Map<String, dynamic> json) => BayarBebasResponse(
    isCorrect: json["is_correct"],
    pembayaran: json["pembayaran"],
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
    message: json["message"],
  );

}

class Detail {
  Detail({
    this.detailBulan,
  });

  DetailBulan? detailBulan;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    detailBulan: DetailBulan.fromJson(json["detail_bulan"]),
  );

}

class DetailBulan {
  DetailBulan({
    this.bebas,
    this.bebasBill,
    this.bebasTotalPay,
    this.bebasId,
    this.period,
    this.sisa,
    this.nominalBayar
  });

  String? bebas;
  String? bebasBill;
  String? bebasTotalPay;
  String? bebasId;
  String? period;
  int? sisa;
  bool processPaid = false;
  double? nominalBayar = null;

  factory DetailBulan.fromJson(Map<String, dynamic> json) => DetailBulan(
    bebas: json["bebas"],
    bebasBill: json["bebas_bill"],
    bebasTotalPay: json["bebas_total_pay"],
    bebasId: json["bebas_id"],
    period: json["period"],
    sisa: json["sisa"],
  );

  Map<String, dynamic> toJson() => {
    "bebas": bebas,
    "bebas_bill": bebasBill,
    "bebas_total_pay": bebasTotalPay,
    "bebas_id": bebasId,
    "period": period,
    "sisa": sisa,
  };
}
