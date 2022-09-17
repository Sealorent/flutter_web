import 'package:equatable/equatable.dart';

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
