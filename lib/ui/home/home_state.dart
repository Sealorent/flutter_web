import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../network/response/information_response.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends HomeState {
  @override
  List<Object> get props => [];
}

class FailedState extends HomeState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetInformationSuccess extends HomeState {
  InformationResponse? response;

  GetInformationSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetInformationLoading extends HomeState {
  GetInformationLoading();

  @override
  List<Object?> get props => [];
}
