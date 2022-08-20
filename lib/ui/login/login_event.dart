import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class LoginPesantren extends LoginEvent {
  @override
  List<Object> get props => [];

  String code;

  LoginPesantren(this.code);
}

class LoginStudent extends LoginEvent {
  @override
  List<Object> get props => [];

  String nis;
  String password;

  LoginStudent(this.nis, this.password);
}
