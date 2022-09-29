import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/history_response.dart';
import 'package:pesantren_flutter/network/response/mudif_response.dart';
import 'package:pesantren_flutter/network/response/payment_bebas_response.dart';
import 'package:pesantren_flutter/network/response/payment_response.dart';
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';
import 'package:pesantren_flutter/network/response/saving_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';

import '../../network/response/bayar_response.dart';
import '../../network/response/information_response.dart';

class PaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends PaymentState {
  @override
  List<Object> get props => [];
}

class FailedState extends PaymentState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class GetPaymentSuccess extends PaymentState {
  PaymentResponse? response;

  GetPaymentSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetPaymentBebasSuccess extends PaymentState {
  PaymentBebasResponse? response;

  GetPaymentBebasSuccess(this.response);

  @override
  List<Object?> get props => [];
}

class GetPaymentLoading extends PaymentState {
  GetPaymentLoading();

  @override
  List<Object?> get props => [];
}

class GetPaymentBebasLoading extends PaymentState {
  GetPaymentBebasLoading();

  @override
  List<Object?> get props => [];
}

class GetDetailBayarLoading extends PaymentState {
  GetDetailBayarLoading();

  @override
  List<Object?> get props => [];
}

class GetDetailBayarSuccess extends PaymentState {
  Object response;

  GetDetailBayarSuccess(this.response);

  @override
  List<Object?> get props => [];
}


class GetHistoryLoading extends PaymentState {
  GetHistoryLoading();

  @override
  List<Object?> get props => [];
}

class GetHistorySuccess extends PaymentState {
  HistoryResponse response;

  GetHistorySuccess(this.response);

  @override
  List<Object?> get props => [];
}


class BayarLoading extends PaymentState {
  BayarLoading();

  @override
  List<Object?> get props => [];
}

class BayarSuccess extends PaymentState {

  BayarResponse response;

  BayarSuccess(this.response);

  @override
  List<Object?> get props => [];
}


class GetRingkasanLoading extends PaymentState {
  GetRingkasanLoading();

  @override
  List<Object?> get props => [];
}

class GetRingkasanSuccess extends PaymentState {

  RingkasanResponse response;

  GetRingkasanSuccess(this.response);

  @override
  List<Object?> get props => [];
}