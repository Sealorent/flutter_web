import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/param/bayar_param.dart';

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
