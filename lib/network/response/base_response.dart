// To parse this JSON data, do
//
//     final baseResponse = baseResponseFromJson(jsonString);

import 'dart:convert';

BaseResponse baseResponseFromJson(String str) => BaseResponse.fromJson(json.decode(str));

String baseResponseToJson(BaseResponse data) => json.encode(data.toJson());

class BaseResponse {
  BaseResponse({
    this.isCorrect,
    this.message,
    this.link
  });

  bool? isCorrect;
  String? message;
  String? link;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
    isCorrect: json["is_correct"],
    message: json["message"],
    link: json["link"]
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
  };
}
