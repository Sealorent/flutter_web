class DetailTransaksiTabunganModel {
  bool? isCorrect;
  String? noref;
  String? bayarVia;
  String? bank;
  String? label;
  String? va;
  String? payment;
  String? expired;
  String? status;
  String? message;

  DetailTransaksiTabunganModel(
      {this.isCorrect,
      this.noref,
      this.bayarVia,
      this.bank,
      this.label,
      this.va,
      this.payment,
      this.expired,
      this.status,
      this.message});

  DetailTransaksiTabunganModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    noref = json['noref'];
    bayarVia = json['bayar_via'];
    bank = json['bank'];
    label = json['label'];
    va = json['va'];
    payment = json['payment'];
    expired = json['expired'];
    status = json['status'];
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
    data['message'] = message;
    return data;
  }
}