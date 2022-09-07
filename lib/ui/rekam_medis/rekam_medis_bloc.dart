import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_event.dart';
import 'package:pesantren_flutter/ui/rekam_medis/rekam_medis_state.dart';



class RekamMedisBloc extends Bloc<RekamMedisEvent, RekamMedisState> {
  MainRepository repository;

  RekamMedisBloc(this.repository) : super(InitialState());

  @override
  Stream<RekamMedisState> mapEventToState(RekamMedisEvent event) async* {
    if (event is GetRekamMedis) {
      try {
        yield GetRekamMedisLoading();
        var response = await repository.getRekamMedis();
        yield GetRekamMedisSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }

    if (event is GetPresensi) {
      try {
        yield GetPresensiLoading();
        var response = await repository.getPresensi(event.bulan);
        yield GetPresensiSuccess(response);
      } catch (e) {
        yield FailedState("Login gagal, silahkan coba lagi", 0);
      }
    }
  }

}
