class ListTransaksiTabunganModel {
  bool? isCorrect;
  List<ListTransaksiTabungan>? listTransaksitabungan;
  String? message;
}

class ListTransaksiTabungan {
  String? idTransaksi;
  String? status;
  String? noref;
  String? tanggal;

  ListTransaksiTabungan({this.idTransaksi, this.status, this.noref, this.tanggal});

  ListTransaksiTabungan.fromJson(Map<String, dynamic> json) {
    idTransaksi = json['id_transaksi'];
    status = json['status'];
    noref = json['noref'];
    tanggal = json['tanggal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_transaksi'] = idTransaksi;
    data['status'] = status;
    data['noref'] = noref;
    data['tanggal'] = tanggal;
    return data;
  }
}