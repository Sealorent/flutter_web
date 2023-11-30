import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/pesantren_login_response.dart';
import 'package:pesantren_flutter/network/response/student_login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../constant.dart';
import '../network_exception.dart';
import '../param/edit_profile_param.dart';
import '../param/login_param.dart';
import '../response/login_response.dart';
import '../response/setting_response.dart';

abstract class AuthenticationRepository {
  Future<PesantrenLoginResponse?> loginPesantren(String code);

  Future<StudentLoginResponse?> loginStudent(String nis, String password);
  Future<Object> editProfile(EditProfileParam param);
  Future<SettingResponse> getSetting();
  Future<Object> changePassword(
      String newPassword, String confirmNewPassword, String oldPassword);
  Future<Object> refreshProfile();
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  Future<StudentLoginResponse> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.student);
    var objectStudent =
        StudentLoginResponse.fromJson(json.decode(student ?? ""));
    return objectStudent;
  }

  final Dio _dioClient;

  Future<PesantrenLoginResponse> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren =
        PesantrenLoginResponse.fromJson(json.decode(pesantren ?? ""));
    return objectpesantren;
  }

  AuthenticationRepositoryImpl(this._dioClient);

  @override
  Future<String?> getNis() async {
    var strudents = await _getUser();
    var student = strudents.nis;

    return student;
  }

  Future<String?> getKodeSekolah() async {
    var strudents = await _getPesantren();
    var school = strudents.kodeSekolah;
    return school;
  }

  Future getTokenFcm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var getToken = prefs.getString('FCM_TOKEN');
    return getToken;
  }

  Future<StudentLoginResponse?> loginStudent(
      String nis, String password) async {
    var pesantren = await _getPesantren();
    // var fcm_token = await getTokenFcm();
    // print("fcm_token $fcm_token");
    try {
      final response = await _dioClient.get(Constant.loginStudent,
          queryParameters: {
            "kode_sekolah": pesantren.kodeSekolah,
            "nis": nis,
            "password": password,
            "fcm_token": "",
          });
      print("response login ${response.data}");
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var data = StudentLoginResponse.fromJson(response.data);
        if (data.isCorrect == true) {
          await getSetting();
          return data;
        } else {
          throw ClientErrorException(statusMessage, statusCode);
        }
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PesantrenLoginResponse?> loginPesantren(String code) async {
    try {
      final response = await _dioClient.get(Constant.loginPesantren,
          queryParameters: {"kode_sekolah": code});
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var resp = PesantrenLoginResponse.fromJson(response.data);
        if (resp.isCorrect == true) {
          return resp;
        } else {
          throw ClientErrorException("Wrong id", 12);
        }
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Object> changePassword(
      String newPassword, String confirmNewPassword, String oldPassword) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    var data = FormData.fromMap({
      'student_nis': student.nis,
      'kode_sekolah': pesantren.kodeSekolah,
      'password_lama': oldPassword,
      'password_baru': newPassword,
      'konfirmasi_password': confirmNewPassword,
    });
    try {
      final response =
          await _dioClient.post(Constant.changePassword, data: data);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return true;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      print("Gilang2 ${ex.message}");
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      print("Gilang1 ${e}");
      throw Exception(e);
    }
  }

  @override
  Future<Object> editProfile(EditProfileParam param) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.student_nis = student.nis;
    param.kode_sekolah = pesantren.kodeSekolah;
    try {
      var data = await param.toFormData();
      final response = await _dioClient.post(Constant.editProfile, data: data);
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return true;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      print("Gilang2 ${ex.message}");
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      print("Gilang1 ${e}");
      throw Exception(e);
    }
  }

  @override
  Future<SettingResponse> getSetting() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.setting, queryParameters: {
        "kode_sekolah": pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return SettingResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Object> refreshProfile() async {
    var pesantren = await _getPesantren();
    var user = await _getUser();
    try {
      final response = await _dioClient.get(Constant.profile, queryParameters: {
        "kode_sekolah": pesantren.kodeSekolah,
        "nis": user.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var data = StudentLoginResponse.fromJson(response.data);
        if (data.isCorrect == true) {
          return data;
        } else {
          throw ClientErrorException(statusMessage, statusCode);
        }
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }
}
