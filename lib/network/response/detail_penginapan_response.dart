class DetailPenginapanResponse {
  bool isCorrect;
  dynamic detail;
  String message;

  DetailPenginapanResponse({
    required this.isCorrect,
    required this.detail,
    required this.message,
  });

  factory DetailPenginapanResponse.fromJson(Map<String, dynamic> json) {
    return DetailPenginapanResponse(
      isCorrect: json['is_correct'],
      detail: json['laporan'] is String ? json['laporan'] : (json['laporan'] as List).map((e) => Data.fromJson(e)).toList(),
      message: json['message'],
    );
  }
}

class Data {
  String gallery;

  Data({required this.gallery});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      gallery: json['gallery'],
    );
  }
}