import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pesantren_flutter/network/response/pesantren_login_response.dart';
import 'package:pesantren_flutter/network/response/student_login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../preferences/pref_data.dart';
import '../constant.dart';
import '../network_exception.dart';
import '../param/login_param.dart';
import '../response/login_response.dart';


abstract class AuthenticationRepository {
  Future<PesantrenLoginResponse?> loginPesantren(String code);

  Future<StudentLoginResponse?> loginStudent(String nis, String password);
}

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final Dio _dioClient;

  Future<PesantrenLoginResponse> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren = PesantrenLoginResponse.fromJson(json.decode(pesantren ?? ""));
    return objectpesantren;
  }

  AuthenticationRepositoryImpl(this._dioClient);

  @override
  Future<StudentLoginResponse?> loginStudent(String nis, String password) async {
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.loginStudent, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": nis,
        "password": password
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return StudentLoginResponse.fromJson(response.data);
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
      final response = await _dioClient.get(Constant.loginPesantren, queryParameters: {
        "kode_sekolah" : code
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return PesantrenLoginResponse.fromJson(response.data);
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
