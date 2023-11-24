part of 'penginapan_bloc.dart';

 class PenginapanState extends Equatable {
  const PenginapanState();
  
  @override
  List<Object> get props => [];
}

class PenginapanInitial extends PenginapanState {}


class Loading extends PenginapanState {
  @override
  List<Object> get props => [];
}

class Error extends PenginapanState {
  final String message;
  final int code;

  Error(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class PenginapanSuccess extends PenginapanState {
  final PenginapanResponse? response;

  PenginapanSuccess(this.response);

  @override
  List<Object> get props => [];
}
