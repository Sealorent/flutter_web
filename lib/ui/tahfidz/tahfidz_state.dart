import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';

import '../../network/response/information_response.dart';

class TahfidzState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends TahfidzState {
  @override
  List<Object> get props => [];
}

class FailedState extends TahfidzState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetTahfidzSuccess extends TahfidzState {
  TahfidzResponse? response;

  GetTahfidzSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetTahfidzLoading extends TahfidzState {
  GetTahfidzLoading();

  @override
  List<Object?> get props => [];
}
