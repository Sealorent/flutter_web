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
        var response = await repository.getPayments(event.periodIds);
        yield GetPaymentSuccess(response);
      } catch (e) {
        yield FailedState("error : get payment", 0);
      }
    }

    if (event is GetPaymentBebas) {
      try {
        yield GetPaymentBebasLoading();
        var response = await repository.getPaymentBebas(event.periodIds);
        yield GetPaymentBebasSuccess(response);
      } catch (e) {
        yield FailedState("error : GetPaymentBebas", 0);
      }
    }

    if (event is GetDetailPaymentBebas) {
      try {
        yield GetDetailBayarLoading();
        var response = await repository.getBayarBebas(event.periodIds);
        yield GetDetailBayarSuccess(response);
      } catch (e) {
        yield FailedState("error : GetDetailPaymentBebas", 0);
      }
    }

    if (event is GetDetailPaymentBulanan) {
      try {
        yield GetDetailBayarLoading();
        var response = await repository.getBayarBulanan(event.periodIds);
        yield GetDetailBayarSuccess(response);
      } catch (e) {
        yield FailedState("error : GetDetailPaymentBulanan", 0);
      }
    }

    if (event is GetHistory) {
      try {
        yield GetHistoryLoading();
        var response = await repository.getHistory();
        yield GetHistorySuccess(response);
      } catch (e) {
        yield FailedState("error : GetHistory", 0);
      }
    }

    if (event is BayarTagihan) {
      try {
        yield BayarLoading();
        var bayarResponse = await repository.bayar(event.param);
        yield BayarSuccess(bayarResponse);
      } catch (e) {
        print("error : BayarTagihan");
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetRingkasan) {
      try {
        yield GetRingkasanLoading();
        var response = await repository.getRingkasan(event.noIpaymu,event.removedBebas,event.removedBulanan);
        yield GetRingkasanSuccess(response);
      } catch (e) {
        print("error : GetRingkasan");
        yield FailedState("error : GetRingkasan", 0);
      }
    }

    if (event is InsertIpaymu) {
      try {
        yield InsertIpaymuLoading();
        if(event.isSaving){
          await repository.insertIpaymuTabungan(event.ipaymu);
        }else{
          await repository.insertIpaymu(event.ipaymu);
        }
        yield InsertIpaymuSuccess();
      } catch (e) {
        yield FailedState("error : InsertIpaymu", 0);
      }
    }

    if (event is GetCaraPembayaran) {
      try {
        yield GetCaraPembayaranLoading();
        var ipaymu = event.ipaymu;
        if(ipaymu != null){
          var resp = await repository.getCaraPemabayaran(ipaymu, event.isSaving);
          yield GetCaraPembayaranSuccess(resp);
        }else{
          yield FailedState("error : cara pembayaran 2", 0);
        }
      } catch (e) {
        print("error: ${e}");
        yield FailedState("error : GetCaraPembayaran ${e}", 0);
      }
    }

    if (event is TopUpTabungan) {
      try {
        yield TopUpTabunganLoading();
        var resp = await repository.topUpTabungan(event.param);
        yield TopUpTabunganSuccess(resp);
      } catch (e) {
        yield FailedState("error : TopUpTabungan", 0);
      }
    }

    if (event is UnduhTagihan) {
      try {
        yield UnduhTagihanLoading();
        var resp = await repository.unduhTagihan();
        yield UnduhTagihanSuccess(resp);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
