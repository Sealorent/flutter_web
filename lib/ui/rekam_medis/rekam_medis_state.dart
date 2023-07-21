import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/presensi_pelajaran_response.dart';
import 'package:pesantren_flutter/network/response/presensi_response.dart';
import 'package:pesantren_flutter/network/response/rekam_medis_response.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';

import '../../network/response/information_response.dart';

class RekamMedisState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends RekamMedisState {
  @override
  List<Object> get props => [];
}

class FailedState extends RekamMedisState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetRekamMedisSuccess extends RekamMedisState {
  RekamMedisResponse? response;

  GetRekamMedisSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetRekamMedisLoading extends RekamMedisState {
  GetRekamMedisLoading();

  @override
  List<Object?> get props => [];
}

class GetPresensiSuccess extends RekamMedisState {
  PresensiResponse? response;

  GetPresensiSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetPresensiLoading extends RekamMedisState {
  GetPresensiLoading();

  @override
  List<Object?> get props => [];
}

class GetPresensiPelajaranSuccess extends RekamMedisState {
  PresensiPelajaranResponse? response;

  GetPresensiPelajaranSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetPresensiPelajaranLoading extends RekamMedisState {
  GetPresensiPelajaranLoading();

  @override
  List<Object?> get props => [];
}
