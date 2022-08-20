import 'dart:convert';

import 'package:alice_lightweight/alice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/response/login_response.dart';
import 'package:pesantren_flutter/network/response/pesantren_login_response.dart';
import 'package:pesantren_flutter/network/response/student_login_response.dart';
import 'package:pesantren_flutter/utils/screen_utils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../preferences/pref_data.dart';
import 'constant.dart';

class DioClient {
  Dio init(Alice? alice, BuildContext context, {bool isNewApi = false}) {
    Dio dio = Dio();
    dio.interceptors.add(ApiInterceptors(context));
    if (alice != null) dio.interceptors.add(alice.getDioInterceptor());
    dio.interceptors.add(
      PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90),
    );
    dio.options.contentType = 'application/json';
    dio.options.baseUrl = Constant.baseUrl;
    dio.options.connectTimeout = Constant.writeTimeout;
    dio.options.receiveTimeout = Constant.readTimeout;
    return dio;
  }
}

class ApiInterceptors extends Interceptor {

  BuildContext context;


  ApiInterceptors(this.context);

  void _savePesantrenInfo(PesantrenLoginResponse? pesantrenLoginResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefData.pesantren, jsonEncode(pesantrenLoginResponse?.toJson()));
  }

  void _saveUserInfo(StudentLoginResponse? studentLoginResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefData.student, jsonEncode(studentLoginResponse?.toJson()));
  }

  void _clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    if (response.statusCode == Constant.successCode) {
      if (response.realUri.path.contains(Constant.loginPesantren)) {
        _savePesantrenInfo(PesantrenLoginResponse.fromJson(response.data));
      }

      if (response.realUri.path.contains(Constant.loginStudent)) {
        _saveUserInfo(StudentLoginResponse.fromJson(response.data));
      }
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    var statusCode = err.response?.statusCode ?? -1;
    if (statusCode == 401) {
      Navigator.pop(context);
      // ScreenUtils(context).navigateTo(LoginS)
      _clearToken();
    }
  }
}
