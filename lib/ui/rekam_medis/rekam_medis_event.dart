import 'package:equatable/equatable.dart';

abstract class RekamMedisEvent extends Equatable {}

class GetRekamMedis extends RekamMedisEvent {
  @override
  List<Object> get props => [];

  GetRekamMedis();
}

class GetPresensi extends RekamMedisEvent {

  int bulan;

  @override
  List<Object> get props => [];

  GetPresensi(this.bulan);
}

