import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/network/response/donasi_response.dart';

part 'donasi_event.dart';
part 'donasi_state.dart';

class DonasiBloc extends Bloc<DonasiEvent, DonasiState> {
  MainRepository repository;
  
  DonasiBloc(this.repository) : super(DonasiInitial());


    @override
  Stream<DonasiState> mapEventToState(DonasiEvent event) async* {
    if (event is GetDonasi ) {
      try {
        yield Loading();
        var response = await repository.donasi();
        yield DonasiSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }
  }
}
