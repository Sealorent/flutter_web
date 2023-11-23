part of 'presensi_bloc.dart';

abstract class PresensiEvent extends Equatable {
  const PresensiEvent();

  @override
  List<Object> get props => [];
}

class GetLesson extends PresensiEvent {

  @override
  List<Object> get props => [];
}


class GetSemester extends PresensiEvent {

  @override
  List<Object> get props => [];
}

class GetPresensiNew extends PresensiEvent {
  final String? lessonId;
  final String? semesterId;
  final String? month;
  final String? periodId;

  GetPresensiNew(this.lessonId, this.semesterId, this.month, this.periodId);

  @override
  List<Object> get props => [lessonId!, semesterId! , month!];
}


class GetTahunAjaran extends PresensiEvent{
  
  GetTahunAjaran();

  @override
  List<Object> get props => [];
}
