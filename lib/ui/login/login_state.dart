import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends LoginState {
  @override
  List<Object> get props => [];
}

class FailedState extends LoginState {
  final String message;
  final int code;

  FailedState(this.message, this.code);

  @override
  List<Object> get props => [message, code];
}

class LoginSuccess extends LoginState {
  LoginSuccess();

  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  LoginLoading();

  @override
  List<Object?> get props => [];
}

class EditProfileSuccess extends LoginState {
  EditProfileSuccess();

  @override
  List<Object?> get props => [];
}

class EditProfileLoading extends LoginState {
  EditProfileLoading();

  @override
  List<Object?> get props => [];
}
