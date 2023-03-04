class DetailTransaksiModel {
  bool? isCorrect;
  String? noref;
  String? bayarVia;
  String? bank;
  String? label;
  String? va;
  String? payment;
  String? expired;
  String? status;
  List<Bulan>? bulan;
  List<Bebas>? bebas;
  String? message;

  DetailTransaksiModel(
      {this.isCorrect,
      this.noref,
      this.bayarVia,
      this.bank,
      this.label,
      this.va,
      this.payment,
      this.expired,
      this.status,
      this.bulan,
      this.bebas,
      this.message});

  DetailTransaksiModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    noref = json['noref'];
    bayarVia = json['bayar_via'];
    bank = json['bank'];
    label = json['label'];
    va = json['va'];
    payment = json['payment'];
    expired = json['expired'];
    status = json['status'];
    if (json['bulan'] != null) {
      bulan = <Bulan>[];
      json['bulan'].forEach((v) {
        bulan!.add(new Bulan.fromJson(v));
      });
    }
    if (json['bebas'] != null) {
      bebas = <Bebas>[];
      json['bebas'].forEach((v) {
        bebas!.add(new Bebas.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_correct'] = isCorrect;
    data['noref'] = noref;
    data['bayar_via'] = bayarVia;
    data['bank'] = bank;
    data['label'] = label;
    data['va'] = va;
    data['payment'] = payment;
    data['expired'] = expired;
    data['status'] = status;
    if (bulan != null) {
      data['bulan'] = bulan!.map((v) => v.toJson()).toList();
    }
    if (bebas != null) {
      data['bebas'] = bebas!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Bulan {
  String? bulanId;
  String? namaBayar;
  String? nominal;

  Bulan({this.bulanId, this.namaBayar, this.nominal});

  Bulan.fromJson(Map<String, dynamic> json) {
    bulanId = json['bulan_id'];
    namaBayar = json['nama_bayar'];
    nominal = json['nominal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bulan_id'] = bulanId;
    data['nama_bayar'] = namaBayar;
    data['nominal'] = nominal;
    return data;
  }
}

class Bebas {
  String? bebasId;
  String? namaBayar;
  String? nominal;

  Bebas({this.bebasId, this.namaBayar, this.nominal});

  Bebas.fromJson(Map<String, dynamic> json) {
    bebasId = json['bebas_id'];
    namaBayar = json['nama_bayar'];
    nominal = json['nominal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bebas_id'] = bebasId;
    data['nama_bayar'] = namaBayar;
    data['nominal'] = nominal;
    return data;
  }
}
