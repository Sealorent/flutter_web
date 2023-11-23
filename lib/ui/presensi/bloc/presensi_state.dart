part of 'presensi_bloc.dart';

abstract class PresensiState extends Equatable {
  const PresensiState();
  
  @override
  List<Object> get props => [];
}

class PresensiInitial extends PresensiState {
  @override
  List<Object> get props => [];
}

class LessonSuccess extends PresensiState {
  final LessonResponse? response;

  LessonSuccess(this.response);

  @override
  List<Object> get props => [];
}


class SemesterSuccess extends PresensiState {
  final SemesterResponse? response;

  SemesterSuccess(this.response);

  @override
  List<Object> get props => [];
}

class PresensiNewSuccess extends PresensiState{
  final PresensiResponseNew? response;

  PresensiNewSuccess(this.response);

  @override
  List<Object> get props => [];
}


class TahunAjaranSuccess extends PresensiState{

  final TahunAjaranResponse? response;

  TahunAjaranSuccess(this.response);

  @override
  List<Object> get props => [];
}


class GetPresensiNewSuccess extends PresensiState {
  final PresensiResponseNew? response;

  GetPresensiNewSuccess(this.response);

  @override
  List<Object> get props => [];
}

class Loading extends PresensiState {
  @override
  List<Object> get props => [];
}

class Error extends PresensiState {
  final String message;
  final int code;

  Error(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

