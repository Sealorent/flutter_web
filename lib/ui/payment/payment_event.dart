import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/param/bayar_param.dart';

import '../../network/param/ipaymu_param.dart';
import '../../network/param/top_up_tabungan_param.dart';

abstract class PaymentEvent extends Equatable {}

class GetPayment extends PaymentEvent {
  @override
  List<Object> get props => [];

  List<int> periodIds;

  GetPayment(this.periodIds);
}

class GetPaymentBebas extends PaymentEvent {
  @override
  List<Object> get props => [];
  List<int> periodIds;

  GetPaymentBebas(this.periodIds);
}

class GetDetailPaymentBulanan extends PaymentEvent {
  List<int> periodIds;
  @override
  List<Object> get props => [];

  GetDetailPaymentBulanan(this.periodIds);
}

class GetDetailPaymentBebas extends PaymentEvent {
  List<int> periodIds;
  @override
  List<Object> get props => [];

  GetDetailPaymentBebas(this.periodIds);
}

class GetHistory extends PaymentEvent {
  @override
  List<Object> get props => [];

  GetHistory();
}

class BayarTagihan extends PaymentEvent {
  BayarParam param;

  @override
  List<Object> get props => [];

  BayarTagihan(this.param);
}


class GetRingkasan extends PaymentEvent {
  String noIpaymu;
  List<int> removedBebas;
  List<int> removedBulanan;

  @override
  List<Object> get props => [];

  GetRingkasan(this.noIpaymu,this.removedBebas,this.removedBulanan);
}


class InsertIpaymu extends PaymentEvent {
  IpaymuParam ipaymu;
  bool isSaving;

  @override
  List<Object> get props => [];

  InsertIpaymu(this.ipaymu,this.isSaving);
}

class GetCaraPembayaran extends PaymentEvent {
  IpaymuParam? ipaymu;
  bool isSaving;

  @override
  List<Object> get props => [];

  GetCaraPembayaran(this.ipaymu,this.isSaving);
}

class TopUpTabungan extends PaymentEvent {
  TopUpTabunganParam param;

  @override
  List<Object> get props => [];

  TopUpTabungan(this.param);
}

class UnduhTagihan extends PaymentEvent {
  @override
  List<Object> get props => [];

  UnduhTagihan();
}