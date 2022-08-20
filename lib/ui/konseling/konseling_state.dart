import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/konseling_response.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';

import '../../network/response/information_response.dart';

class KonselingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends KonselingState {
  @override
  List<Object> get props => [];
}

class FailedState extends KonselingState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetKonselingSuccess extends KonselingState {
  KonselingResponse? response;

  GetKonselingSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetKonselingLoading extends KonselingState {
  GetKonselingLoading();

  @override
  List<Object?> get props => [];
}
