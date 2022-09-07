import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/param/izin_pulang_param.dart';

import '../../network/param/izin_keluar_param.dart';

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

class AddIzinPulang extends IzinEvent {
  IzinPulangParam param;

  @override
  List<Object> get props => [];

  AddIzinPulang(this.param);
}

class AddIzinKeluar extends IzinEvent {
  IzinKeluarParam param;

  @override
  List<Object> get props => [];

  AddIzinKeluar(this.param);
}

