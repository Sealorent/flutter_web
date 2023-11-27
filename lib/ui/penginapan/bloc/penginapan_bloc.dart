import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/network/response/detail_penginapan_response.dart';
import 'package:pesantren_flutter/network/response/list_homestay_response.dart';

part 'penginapan_event.dart';
part 'penginapan_state.dart';

class PenginapanBloc extends Bloc<PenginapanEvent, PenginapanState> {
  MainRepository repository;
  
  PenginapanBloc(this.repository) : super(PenginapanInitial());

   @override
  Stream<PenginapanState> mapEventToState(PenginapanEvent event) async* {
    if (event is GetPenginapan ) {
      try {
        yield Loading();
        var response = await repository.getHomeStay();
        yield PenginapanSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }

    if (event is GetDetailPenginapan ) {
      try {
        yield Loading();
        var response = await repository.getDetailPenginapan(event.homestayId);
        yield DetailSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }
  }
}
