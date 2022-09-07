// To parse this JSON data, do
//
//     final informationResponse = informationResponseFromJson(jsonString);

import 'dart:convert';

InformationResponse informationResponseFromJson(String str) => InformationResponse.fromJson(json.decode(str));

class InformationResponse {
  InformationResponse({
    this.isCorrect,
    this.message,
    this.informasi,
  });

  bool? isCorrect;
  String? message;
  List<Informasi>? informasi;

  factory InformationResponse.fromJson(Map<String, dynamic> json) => InformationResponse(
    isCorrect: json["is_correct"],
    message: json["message"],
    informasi: List<Informasi>.from(json["informasi"].map((x) => Informasi.fromJson(x))),
  );

}

class Informasi {
  Informasi({
    this.tanggal,
    this.detail,
  });

  DateTime? tanggal;
  Detail? detail;

  factory Informasi.fromJson(Map<String, dynamic> json) => Informasi(
    tanggal: DateTime.now(),
    detail: Detail.fromJson(json["detail"]),
  );

}

class Detail {
  Detail({
    this.judulInfo,
    this.image,
    this.detailInfo,
  });

  String? judulInfo;
  String? image;
  String? detailInfo;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    judulInfo: json["judul_info"],
    image: json["image"] == null ? null : json["image"],
    detailInfo: json["detail_info"],
  );

  Map<String, dynamic> toJson() => {
    "judul_info": judulInfo,
    "image": image == null ? null : image,
    "detail_info": detailInfo,
  };
}
