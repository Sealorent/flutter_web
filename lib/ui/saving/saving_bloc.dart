import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/saving/saving_event.dart';
import 'package:pesantren_flutter/ui/saving/saving_state.dart';

class SavingBloc extends Bloc<SavingEvent, SavingState> {
  MainRepository repository;

  SavingBloc(this.repository) : super(InitialState());

  @override
  Stream<SavingState> mapEventToState(SavingEvent event) async* {
    if (event is GetSavings) {
      try {
        yield GetSavingLoading();
        var response = await repository.getSavings();
        yield GetSavingSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }
}
