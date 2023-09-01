// To parse this JSON data, do
//
//     final paymentResponse = paymentResponseFromJson(jsonString);

import 'dart:convert';

import 'package:pesantren_flutter/ui/payment/bulanan/bulanan_model.dart';

import '../../ui/transaction/model/item_filter_model.dart';

PaymentResponse paymentResponseFromJson(String str) =>
    PaymentResponse.fromJson(json.decode(str));

class PaymentResponse {
  PaymentResponse({
    this.isCorrect,
    this.pembayaran,
    this.detail,
    this.message,
  });

  bool? isCorrect;
  String? pembayaran;
  List<Detail>? detail;
  String? message;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        isCorrect: json["is_correct"],
        pembayaran: json["pembayaran"],
        detail:
            List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
        message: json["message"],
      );
}

class Detail {
  Detail({
    this.detailBulan,
  });

  Map<String, String>? detailBulan;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        detailBulan: Map.from(json["detail_bulan"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  BulananModel fromModel() {
    return BulananModel(
        detailBulan?["nama_bayar"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["total"]?.toString() ?? "",
        detailBulan?["dibayar"]?.toString() ?? "", [
      BulananItemModel(
        detailBulan?["month_name_jul"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["bill_jul"]?.toString() ?? "",
        detailBulan?["status_jul"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_agu"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["bill_agu"]?.toString() ?? "",
        detailBulan?["status_agu"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_sep"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["bill_sep"]?.toString() ?? "",
        detailBulan?["status_sep"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_okt"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["bill_okt"]?.toString() ?? "",
        detailBulan?["status_okt"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_nov"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["bill_nov"]?.toString() ?? "",
        detailBulan?["status_nov"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_des"]?.toString() ?? "",
        detailBulan?["period_start"]?.toString() ?? "",
        detailBulan?["bill_des"]?.toString() ?? "",
        detailBulan?["status_des"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_jan"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["bill_jan"]?.toString() ?? "",
        detailBulan?["status_jan"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_feb"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["bill_feb"]?.toString() ?? "",
        detailBulan?["status_feb"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_mar"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["bill_mar"]?.toString() ?? "",
        detailBulan?["status_mar"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_apr"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["bill_apr"]?.toString() ?? "",
        detailBulan?["status_apr"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_mei"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["bill_mei"]?.toString() ?? "",
        detailBulan?["status_mei"]?.toString() ?? "",
      ),
      BulananItemModel(
        detailBulan?["month_name_jun"]?.toString() ?? "",
        detailBulan?["period_end"]?.toString() ?? "",
        detailBulan?["bill_jun"]?.toString() ?? "",
        detailBulan?["status_jun"]?.toString() ?? "",
      ),
    ]);
  }
}
