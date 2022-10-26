import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/param/bayar_param.dart';

import '../../network/param/ipaymu_param.dart';
import '../../network/param/top_up_tabungan_param.dart';

abstract class PaymentEvent extends Equatable {}

class GetPayment extends PaymentEvent {
  @override
  List<Object> get props => [];

  GetPayment();
}

class GetPaymentBebas extends PaymentEvent {
  @override
  List<Object> get props => [];

  GetPaymentBebas();
}

class GetDetailPaymentBulanan extends PaymentEvent {
  @override
  List<Object> get props => [];

  GetDetailPaymentBulanan();
}

class GetDetailPaymentBebas extends PaymentEvent {
  @override
  List<Object> get props => [];

  GetDetailPaymentBebas();
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

  @override
  List<Object> get props => [];

  GetRingkasan(this.noIpaymu);
}


class InsertIpaymu extends PaymentEvent {
  IpaymuParam ipaymu;

  @override
  List<Object> get props => [];

  InsertIpaymu(this.ipaymu);
}

class GetCaraPembayaran extends PaymentEvent {
  IpaymuParam? ipaymu;

  @override
  List<Object> get props => [];

  GetCaraPembayaran(this.ipaymu);
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