class ListTransaksiModel {
  bool? isCorrect;
  List<ListTransaksi>? listTransaksi;
  List<History>? history;
  String? message;

  ListTransaksiModel(
      {this.isCorrect, this.listTransaksi, this.history, this.message});

  ListTransaksiModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    if (json['list_transaksi'] != null) {
      listTransaksi = <ListTransaksi>[];
      json['list_transaksi'].forEach((v) {
        listTransaksi!.add(ListTransaksi.fromJson(v));
      });
    }
    if (json['history'] != null) {
      history = <History>[];
      json['history'].forEach((v) {
        history!.add(History.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_correct'] = isCorrect;
    if (listTransaksi != null) {
      data['list_transaksi'] = listTransaksi!.map((v) => v.toJson()).toList();
    }
    if (history != null) {
      data['history'] = history!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class ListTransaksi {
  String? idTransaksi;
  String? status;
  String? noref;
  String? tanggal;

  ListTransaksi({this.idTransaksi, this.status, this.noref, this.tanggal});

  ListTransaksi.fromJson(Map<String, dynamic> json) {
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

class History {
  String? noRef;
  String? namaBayar;
  String? tanggal;
  String? nominal;
  String? bayarVia;

  History(
      {this.noRef, this.namaBayar, this.tanggal, this.nominal, this.bayarVia});

  History.fromJson(Map<String, dynamic> json) {
    noRef = json['no ref'];
    namaBayar = json['nama_bayar'];
    tanggal = json['tanggal'];
    nominal = json['nominal'];
    bayarVia = json['bayar_via'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no ref'] = noRef;
    data['nama_bayar'] = namaBayar;
    data['tanggal'] = tanggal;
    data['nominal'] = nominal;
    data['bayar_via'] = bayarVia;
    return data;
  }
}
