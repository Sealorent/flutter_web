import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';

import 'login_event.dart';
import 'login_state.dart';



class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthenticationRepository repository;

  LoginBloc(this.repository) : super(InitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginPesantren) {
      try {
        yield LoginLoading();
        await repository.loginPesantren(event.code);
        yield LoginSuccess();
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is LoginStudent) {
      try {
        yield LoginLoading();
        await repository.loginStudent(event.nis, event.password);
        yield LoginSuccess();
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}