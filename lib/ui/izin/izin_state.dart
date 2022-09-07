import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/izin_response.dart';
import 'package:pesantren_flutter/network/response/pulang_response.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';

import '../../network/response/information_response.dart';

class IzinState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends IzinState {
  @override
  List<Object> get props => [];
}

class FailedState extends IzinState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}


class GetIzinLoading extends IzinState {
  GetIzinLoading();

  @override
  List<Object?> get props => [];
}

class GetIzinKeluarSuccess extends IzinState {
  IzinResponse? response;

  GetIzinKeluarSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetIzinPulangSuccess extends IzinState {
  PulangResponse? response;

  GetIzinPulangSuccess(this.response);

  @override
  List<Object?> get props => [];
}


class AddIzinSuccess extends IzinState {

  AddIzinSuccess();

  @override
  List<Object?> get props => [];
}

class AddIzinLoading extends IzinState {

  AddIzinLoading();

  @override
  List<Object?> get props => [];
}
