import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/mudif/mudif_event.dart';
import 'package:pesantren_flutter/ui/mudif/mudif_state.dart';


class MudifBloc extends Bloc<MudifEvent, MudifState> {
  MainRepository repository;

  MudifBloc(this.repository) : super(InitialState());

  @override
  Stream<MudifState> mapEventToState(MudifEvent event) async* {
    if (event is GetMudif) {
      try {
        yield GetMudifLoading();
        var response = await repository.getMudif();
        yield GetMudifSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
