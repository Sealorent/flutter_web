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

  // ignore: non_constant_identifier_names
  void ResetPass(String nis, String kodeSekolah) async {
    if (inputPasswordBaru.text.trim().isEmpty) {
      Get.snackbar("Gagal", "Password Baru Wajib Diisi",
          backgroundColor: Colors.red);
      return;
    }
    if (inputPassword.text.trim().isEmpty) {
      Get.snackbar("Gagal", "Konfirmasi Password Wajib Diisi",
          backgroundColor: Colors.red);
      return;
    }
    if (inputPasswordBaru.text != inputPassword.text) {
      Get.snackbar("Gagal", "Password yang anda Masukkan Tidak Sesuai",
          backgroundColor: Colors.red);

      return;
    }
    var req = dio.Dio();
    String? reset = inputPassword.text.trim();
    var data = {
      'kode_pondok': kodeSekolah,
      'nis': nis,
      'reset': reset,
    };
    var response = await req.post(
        '${Constant.baseUrl}${Constant.resetPassword}',
        data: dio.FormData.fromMap(data));

    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;
    if (res['is_correct'] == true) {
      Get.snackbar("Berhasil", "Password Anda berhasil direset",
          backgroundColor: Colors.green);
      Get.offAll( LoginUserScreen());
    } else {
      Get.snackbar("Gagal", "Data Yang Dimasukkan Salah",
          backgroundColor: Colors.red);
    }
  }
}
