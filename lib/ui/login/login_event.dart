import 'package:equatable/equatable.dart';
import 'package:pesantren_flutter/network/param/edit_profile_param.dart';

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

class EditProfile extends LoginEvent {
  @override
  List<Object> get props => [];

  EditProfileParam param;

  EditProfile(this.param);
}
