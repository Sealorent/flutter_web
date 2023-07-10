import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/home/home_state.dart';

import 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  MainRepository repository;

  HomeBloc(this.repository) : super(InitialState());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetInformation) {
      try {
        yield GetInformationLoading();
        var response = await repository.getInformation();
        yield GetInformationSuccess(response);
        await repository.getTahunAjaran();
      } catch (e) {
        print("informationerr ${e}");
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }
}
