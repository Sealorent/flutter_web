import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/payment/payment_event.dart';
import 'package:pesantren_flutter/ui/payment/payment_state.dart';



class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  MainRepository repository;

  PaymentBloc(this.repository) : super(InitialState());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is GetPayment) {
      try {
        yield GetPaymentLoading();
        var response = await repository.getPayments();
        yield GetPaymentSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetPaymentBebas) {
      try {
        yield GetPaymentBebasLoading();
        var response = await repository.getPaymentBebas();
        yield GetPaymentBebasSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetDetailPaymentBebas) {
      try {
        yield GetDetailBayarLoading();
        var response = await repository.getBayarBebas();
        yield GetDetailBayarSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetDetailPaymentBulanan) {
      try {
        yield GetDetailBayarLoading();
        var response = await repository.getBayarBulanan();
        yield GetDetailBayarSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
