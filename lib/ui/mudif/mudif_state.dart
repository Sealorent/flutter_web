import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/mudif_response.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';

import '../../network/response/information_response.dart';

class MudifState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MudifState {
  @override
  List<Object> get props => [];
}

class FailedState extends MudifState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetMudifSuccess extends MudifState {
  MudifResponse? response;

  GetMudifSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetMudifLoading extends MudifState {
  GetMudifLoading();

  @override
  List<Object?> get props => [];
}
