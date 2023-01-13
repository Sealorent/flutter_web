// To parse this JSON data, do
//
//     final bayarBulananResponse = bayarBulananResponseFromJson(jsonString);

import 'dart:convert';

BayarBulananResponse bayarBulananResponseFromJson(String str) => BayarBulananResponse.fromJson(json.decode(str));

class BayarBulananResponse {
  BayarBulananResponse({
    this.isCorrect,
    this.pembayaran,
    this.detail,
    this.message,
  });

  bool? isCorrect;
  String? pembayaran;
  List<Detail>? detail;
  String? message;

  factory BayarBulananResponse.fromJson(Map<String, dynamic> json) => BayarBulananResponse(
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
    this.row,
    this.bulanBill,
    this.bulanId,
    this.period,
    required this.processPaid
  });

  String? row;
  String? bulanBill;
  String? bulanId;
  String? period;
  bool processPaid = false;

  factory DetailBulan.fromJson(Map<String, dynamic> json) => DetailBulan(
    row: json["row"],
    bulanBill: json["bulan_bill"],
    bulanId: json["bulan_id"],
    period: json["period"],
    processPaid: json["status"]
  );

  Map<String, dynamic> toJson() => {
    "row": row,
    "bulan_bill": bulanBill,
    "bulan_id": bulanId,
    "period": period,
  };
}
