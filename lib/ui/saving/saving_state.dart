import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';

import '../../network/response/information_response.dart';

class SavingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends SavingState {
  @override
  List<Object> get props => [];
}

class FailedState extends SavingState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetSavingSuccess extends SavingState {
  SavingResponse? response;

  GetSavingSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetSavingLoading extends SavingState {
  GetSavingLoading();

  @override
  List<Object?> get props => [];
}
