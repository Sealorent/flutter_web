class KonfirmasiModel {
  bool? isCorrect;
  List<Data>? data;
  String? message;

  KonfirmasiModel({this.isCorrect, this.data, this.message});

  KonfirmasiModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_correct'] = isCorrect;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  String? tanggal;
  Detail? detail;

  Data({this.tanggal, this.detail});

  Data.fromJson(Map<String, dynamic> json) {
    tanggal = json['tanggal'];
    detail = json['detail'] != null ? Detail.fromJson(json['detail']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tanggal'] = tanggal;
    if (detail != null) {
      data['detail'] = detail!.toJson();
    }
    return data;
  }
}

class Detail {
  String? catatan;
  String? status;
  String? gambar;

  Detail({this.catatan, this.status, this.gambar});

  Detail.fromJson(Map<String, dynamic> json) {
    catatan = json['catatan'];
    status = json['status'];
    gambar = json['gambar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catatan'] = catatan;
    data['status'] = status;
    data['gambar'] = gambar;
    return data;
  }
}
