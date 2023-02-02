import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pesantren_flutter/network/constant.dart';

import '../../../network/repository/authentication_repository.dart';

class ProfilController extends GetxController {
  static ProfilController get to => Get.isRegistered<ProfilController>()
      ? Get.find()
      : Get.put(ProfilController());
  bool isLoadingProfil = true;
  bool isUpload = false;

  void postProfil(
      String namaSantri,
      String alamatSantri,
      String tempatLahir,
      String tanggalLahir,
      String ayah,
      String ibu,
      String noWa,
      String kelamin,
      File image) async {
    var req = dio.Dio();
    dio.Options(contentType: 'multipart/form-data');
    String? nis = await AuthenticationRepositoryImpl(req).getNis();
    String? kodeSekolah =
        await AuthenticationRepositoryImpl(req).getKodeSekolah();
    String tanggal =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(tanggalLahir));
    // ignore: unused_local_variable
    String status = "Diajukan";
    String? studentNis = nis;
    String? kodeSekolahPost = kodeSekolah;
    isUpload = true;
    update();
    var data = {
      'kode_sekolah': kodeSekolahPost,
      'student_nis': studentNis,
      'nama_santri': namaSantri,
      'alamat': alamatSantri,
      'tempatlahir': tempatLahir,
      'tanggallahir': tanggal,
      'nomorwa': noWa,
      'gender': kelamin,
      'ayah': ayah,
      'ibu': ibu,
      'student_img':
          // ignore: await_only_futures
          await dio.MultipartFile.fromFile(image.path,
              filename:
                  namaSantri + DateFormat("HH:mm:ss").format(DateTime.now())),
    };
    print("iki data kirim $data");
    var response = await req.post(
      '${Constant.baseUrl}${Constant.editProfile}',
      data: dio.FormData.fromMap(data),
    );
    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;
    isUpload = res['is_correct'];
    update();
    if (res['is_correct'] == true) {
      Fluttertoast.showToast(
          msg: response.data['message'], backgroundColor: Colors.green);
      isUpload = false;
      update();
      Get.back();
    } else {
      Fluttertoast.showToast(
          msg: response.data['message'], backgroundColor: Colors.red);
    }
  }
}
