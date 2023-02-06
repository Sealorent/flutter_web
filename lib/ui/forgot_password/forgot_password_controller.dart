import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/network/constant.dart';
import 'package:pesantren_flutter/ui/forgot_password/forgot_password_model.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pesantren_flutter/ui/verify_password/verify_password.dart';

class GetOtpController extends GetxController {
  static GetOtpController get to => Get.isRegistered<GetOtpController>()
      ? Get.find()
      : Get.put(GetOtpController());

  GetOtpModel? getOtpModel;
  TextEditingController inputKodeSekolah = TextEditingController();
  TextEditingController inputNis = TextEditingController();
  TextEditingController inputWa = TextEditingController();
  bool isLoading = false;

  // ignore: non_constant_identifier_names
  void GetOtpMethod() async {
    update();
    var req = dio.Dio();
    var data = {
      'kode_sekolah': inputKodeSekolah.text,
      'nis': inputNis.text,
      'no_wa': inputWa.text,
    };
    isLoading = true;
    update();
    var response = await req.post('${Constant.baseUrl}${Constant.getOtp}',
        data: dio.FormData.fromMap(data));
    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;

    isLoading = res['is_correct'];
    update();
    if (res['is_correct'] == true) {
      getOtpModel = GetOtpModel.fromJson(res);
      Get.snackbar("Sukses", res['message'],
          colorText: Colors.white, backgroundColor: Colors.green);
      isLoading = false;
      update();
      Get.offAll(
          GetOtp(getOtpModel?.kodeSekolah ?? '', getOtpModel?.nis ?? ''));
    } else {
      Get.snackbar("Gagal", res['message'],
          colorText: Colors.white, backgroundColor: Colors.red);
      isLoading = false;
      update();
    }
  }
}
