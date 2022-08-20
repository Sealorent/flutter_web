import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/konseling/konseling_event.dart';
import 'package:pesantren_flutter/ui/konseling/konseling_state.dart';



class KonselingBloc extends Bloc<KonselingEvent, KonselingState> {
  MainRepository repository;

  KonselingBloc(this.repository) : super(InitialState());

  @override
  Stream<KonselingState> mapEventToState(KonselingEvent event) async* {
    if (event is GetKonseling) {
      try {
        yield GetKonselingLoading();
        var response = await repository.getKonseling();
        yield GetKonselingSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
