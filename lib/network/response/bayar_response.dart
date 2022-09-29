// To parse this JSON data, do
//
//     final bayarResponse = bayarResponseFromJson(jsonString);

import 'dart:convert';

BayarResponse bayarResponseFromJson(String str) => BayarResponse.fromJson(json.decode(str));

String bayarResponseToJson(BayarResponse data) => json.encode(data.toJson());

class BayarResponse {
  BayarResponse({
    this.isCorrect,
    this.noIpaymu,
    this.message,
  });

  bool? isCorrect;
  String? noIpaymu;
  String? message;

  factory BayarResponse.fromJson(Map<String, dynamic> json) => BayarResponse(
    isCorrect: json["is_correct"],
    noIpaymu: json["no_ipaymu"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
    "no_ipaymu": noIpaymu,
    "message": message,
  };
}
