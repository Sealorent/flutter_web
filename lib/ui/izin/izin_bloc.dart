import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/izin/izin_event.dart';
import 'package:pesantren_flutter/ui/izin/izin_state.dart';


class IzinBloc extends Bloc<IzinEvent, IzinState> {
  MainRepository repository;

  IzinBloc(this.repository) : super(InitialState());

  @override
  Stream<IzinState> mapEventToState(IzinEvent event) async* {
    if (event is GetIzinKeluar) {
      try {
        yield GetIzinLoading();
        var response = await repository.getIzinKeluar();
        yield GetIzinKeluarSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
    if (event is GetIzinPulang) {
      try {
        yield GetIzinLoading();
        var response = await repository.getIzinPulang();
        yield GetIzinPulangSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is AddIzinKeluar) {
      try {
        yield AddIzinLoading();
        await repository.postIzinKeluar(event.param);
        yield AddIzinSuccess();
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is AddIzinPulang) {
      try {
        yield AddIzinLoading();
        await repository.postIzinPulang(event.param);
        yield AddIzinSuccess();
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
