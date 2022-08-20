import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_event.dart';
import 'package:pesantren_flutter/ui/tahfidz/tahfidz_state.dart';


class TahfidzBloc extends Bloc<TahfidzEvent, TahfidzState> {
  MainRepository repository;

  TahfidzBloc(this.repository) : super(InitialState());

  @override
  Stream<TahfidzState> mapEventToState(TahfidzEvent event) async* {
    if (event is GetTahfidz) {
      try {
        yield GetTahfidzLoading();
        var response = await repository.getTahfidz();
        yield GetTahfidzSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
