part of 'donasi_bloc.dart';

class DonasiState extends Equatable {
  const DonasiState();
  
  @override
  List<Object> get props => [];
}

class DonasiInitial extends DonasiState {}

class Loading extends DonasiState {}

class Error extends DonasiState {
  final String message;
  final int code;

  Error(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}


class DonasiSuccess extends DonasiState {
  final DonasiResponse? response;

  DonasiSuccess(this.response);

  @override
  List<Object> get props => [];
}

