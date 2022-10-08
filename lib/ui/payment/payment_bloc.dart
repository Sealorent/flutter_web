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

    if (event is GetHistory) {
      try {
        yield GetHistoryLoading();
        var response = await repository.getHistory();
        yield GetHistorySuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is BayarTagihan) {
      try {
        yield BayarLoading();
        var bayarResponse = await repository.bayar(event.param);
        yield BayarSuccess(bayarResponse);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetRingkasan) {
      try {
        yield GetRingkasanLoading();
        var response = await repository.getRingkasan(event.noIpaymu);
        yield GetRingkasanSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is InsertIpaymu) {
      try {
        yield InsertIpaymuLoading();
         await repository.insertIpaymu(event.ipaymu);
        yield InsertIpaymuSuccess();
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetCaraPembayaran) {
      try {
        yield GetCaraPembayaranLoading();
        var ipaymu = event.ipaymu;
        if(ipaymu != null){
          var resp = await repository.getCaraPemabayaran(ipaymu);
          yield GetCaraPembayaranSuccess(resp);
        }else{
          yield FailedState("Login gagal, silahkan coba lagi", 0);
        }
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is TopUpTabungan) {
      try {
        yield TopUpTabunganLoading();
        var resp = await repository.topUpTabungan(event.param);
        yield TopUpTabunganSuccess(resp);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
