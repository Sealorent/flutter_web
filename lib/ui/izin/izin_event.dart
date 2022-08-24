import 'package:equatable/equatable.dart';

abstract class IzinEvent extends Equatable {}

class GetIzinKeluar extends IzinEvent {
  @override
  List<Object> get props => [];

  GetIzinKeluar();
}

class GetIzinPulang extends IzinEvent {
  @override
  List<Object> get props => [];

  GetIzinPulang();
}

