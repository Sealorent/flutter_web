import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pesantren_flutter/network/constant.dart';
import 'package:pesantren_flutter/ui/login/login_user_screen.dart';

class LupaPasswordController extends GetxController {
  static LupaPasswordController get to =>
      Get.isRegistered<LupaPasswordController>()
          ? Get.find()
          : Get.put(LupaPasswordController());
  TextEditingController inputPasswordBaru = TextEditingController();
  TextEditingController inputPassword = TextEditingController();
  bool isLoading = false;

  // ignore: non_constant_identifier_names
  void ResetPass(String nis, String kodeSekolah) async {
    if (inputPasswordBaru.text.trim().isEmpty) {
      Get.snackbar("Gagal", "Password Baru Wajib Diisi",
          backgroundColor: Colors.red);
      isLoading = false;
      update();
      return;
    }
    if (inputPassword.text.trim().isEmpty) {
      Get.snackbar("Gagal", "Konfirmasi Password Wajib Diisi",
          backgroundColor: Colors.red);
      isLoading = false;
      update();
      return;
    }
    if (inputPasswordBaru.text != inputPassword.text) {
      Get.snackbar("Gagal", "Password yang anda Masukkan Tidak Sesuai",
          backgroundColor: Colors.red);
      isLoading = false;
      update();
      return;
    }
    var req = dio.Dio();
    String? reset = inputPassword.text.trim();
    var data = {
      'kode_pondok': kodeSekolah,
      'nis': nis,
      'reset': reset,
    };
    isLoading = true;
    update();
    var response = await req.post(
        '${Constant.baseUrl}${Constant.resetPassword}',
        data: dio.FormData.fromMap(data));

    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;
    isLoading = res['is_correct'];
    update();
    if (res['is_correct'] == true) {
      Get.snackbar("Berhasil", res['message'], backgroundColor: Colors.green);
      isLoading = false;
      update();
      Get.offAll(LoginUserScreen());
    } else {
      Get.snackbar("Gagal", res['message'], backgroundColor: Colors.red);
      isLoading = false;
      update();
    }
  }
}
