import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:pesantren_flutter/network/constant.dart';
import 'package:pesantren_flutter/ui/reset_password/reset_password.dart';
import 'package:pesantren_flutter/ui/verify_password/verify_password_model.dart';

class VerifyOtpController extends GetxController {
  static VerifyOtpController get to => Get.isRegistered<VerifyOtpController>()
      ? Get.find()
      : Get.put(VerifyOtpController());

  VerifyOtpModel? verifyOtpModel;
  TextEditingController inputCode = TextEditingController();
  bool isLoading = false;

  // ignore: non_constant_identifier_names
  void GetOtp(String kodeSekolah, String nis) async {
    var req = dio.Dio();
    var data = {
      'code': inputCode.text,
      'kode_sekolah': kodeSekolah,
      'nis': nis,
    };
    isLoading = true;
    update();
    var response = await req.post('${Constant.baseUrl}${Constant.veriftOtp}',
        data: dio.FormData.fromMap(data));
    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;

    isLoading = res['is_correct'];
    update();
    if (res['is_correct'] == true) {
      verifyOtpModel = VerifyOtpModel.fromJson(res);
      Get.snackbar("Sukses", res['message'],
          backgroundColor: Colors.green, colorText: Colors.white);
      isLoading = false;
      update();
      Get.offAll(ResetPassword(
          verifyOtpModel?.nis ?? '', verifyOtpModel?.kodeSekolah ?? ''));
    } else {
      Get.snackbar("Gagal", res['message'],
          backgroundColor: Colors.red, colorText: Colors.white);
      isLoading = false;
      update();
    }
  }
}
