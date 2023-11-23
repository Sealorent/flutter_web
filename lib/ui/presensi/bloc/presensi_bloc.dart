import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/repository/main_repository.dart';
import 'package:pesantren_flutter/network/response/lesson_response.dart';
import 'package:pesantren_flutter/network/response/presensi_response.dart';
import 'package:pesantren_flutter/network/response/presensi_response_new.dart';
import 'package:pesantren_flutter/network/response/semester_response.dart';
import 'package:pesantren_flutter/network/response/tahun_ajaran_response.dart';


part 'presensi_event.dart';
part 'presensi_state.dart';

class PresensiBloc extends Bloc<PresensiEvent, PresensiState> {
  
  MainRepository repository;
  
  PresensiBloc(this.repository) : super(PresensiInitial());

  @override
  Stream<PresensiState> mapEventToState(PresensiEvent event) async* {
    if (event is GetLesson) {
      try {
        yield Loading();
        var response = await repository.getLesson();
        print('res : $response');
        yield LessonSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }

    if (event is GetSemester) {
      try {
        yield Loading();
        var response = await repository.getSemester();
        print('res semester : $response');
        yield SemesterSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }

    if (event is GetPresensiNew) {
      try {
        yield Loading();
        var response = await repository.getPresensiNew(event.lessonId, event.semesterId, event.month, event.periodId);
        print('res presensi : $response');
        yield PresensiNewSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }

    if(event is GetTahunAjaran){
      try {
        yield Loading();
        var response = await repository.getTahunAjaran();
        print('res tahun ajaran : $response');
        yield TahunAjaranSuccess(response);
      } catch (e) {
        print(e);
        yield Error('error', 0);
      }
    }
    


  }

  

}

