class PenginapanResponse {
  bool isCorrect;
  dynamic homestay;
  String message;

  PenginapanResponse({required this.isCorrect, required this.homestay, required this.message});

  factory PenginapanResponse.fromJson(Map<String, dynamic> json) {
    return PenginapanResponse(
      isCorrect: json['is_correct'],
      // check when data is String
      homestay : json['laporan'] is String ? json['laporan'] : (json['laporan'] as List).map((e) => HomeStay.fromJson(e)).toList(),
      message: json['message'],
    );
  }
}

class HomeStay {
  String homestayId;
  String homestayName;
  String homestayPrice;
  String homestayDesc;
  String homestayLongitude;
  String homestayLatitude;

  HomeStay({
    required this.homestayId,
    required this.homestayName,
    required this.homestayPrice,
    required this.homestayDesc,
    required this.homestayLongitude,
    required this.homestayLatitude,
  });

  factory HomeStay.fromJson(Map<String, dynamic> json) {
    return HomeStay(
      homestayId: json['homestay_id'],
      homestayName: json['homestay_name'],
      homestayPrice: json['homestay_price'],
      homestayDesc: json['homestay_desc'],
      homestayLongitude: json['homestay_longitude'],
      homestayLatitude: json['homestay_latitude'],
    );
  }
}