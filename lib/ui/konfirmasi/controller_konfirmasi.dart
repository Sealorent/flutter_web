import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pesantren_flutter/network/constant.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/ui/konfirmasi/model_konfirmasi.dart';
import 'package:fluttertoast/fluttertoast.dart';

class KonfirmasiController extends GetxController {
  static KonfirmasiController get to => Get.isRegistered<KonfirmasiController>()
      ? Get.find()
      : Get.put(KonfirmasiController());
  List<Data> listKonfirmasi = [];
  bool isLoadingKonfirmasi = true;

  void getKonfirmasi() async {
    var req = dio.Dio();
    String? nis = await AuthenticationRepositoryImpl(req).getNis();
    String? kodeSekolah =
        await AuthenticationRepositoryImpl(req).getKodeSekolah();
    try {
      isLoadingKonfirmasi = true;
      update();
      var data = {
        'nis': nis,
        'kode_sekolah': kodeSekolah,
      };
      var response = await req.post('${Constant.baseUrl}${Constant.konfirmasi}',
          data: dio.FormData.fromMap(data));
      var res = response.data.runtimeType.toString() == "String"
          ? jsonDecode(response.data)
          : response.data;
      if (res['is_correct']) {
        isLoadingKonfirmasi = false;
        update();
        final konfirmasiData = KonfirmasiModel.fromJson(res);
        listKonfirmasi = konfirmasiData.data ?? [];
      }
    } catch (e) {
      print(e);
    }
  }

  void uploadBukti(String keterangan, File image) async {
    var req = dio.Dio();
    dio.Options(contentType: 'multipart/form-data');
    String? nis = await AuthenticationRepositoryImpl(req).getNis();
    String? kodeSekolah =
        await AuthenticationRepositoryImpl(req).getKodeSekolah();
    try {
      var data = {
        'nis': nis,
        'kode_sekolah': kodeSekolah,
        'keterangan': keterangan,
        'upload_img':
            await dio.MultipartFile.fromFile(image.path, filename: image.path)
      };
      var response = await req.post(
          '${Constant.baseUrl}${Constant.uploadBukti}',
          data: dio.FormData.fromMap(data));
      var res = response.data.runtimeType.toString() == "String"
          ? jsonDecode(response.data)
          : response.data;
      if (res['is_correct']) {
        Fluttertoast.showToast(
            msg: response.data['message'],
            backgroundColor: Colors.green,
            textColor: Colors.white);
        Get.back();
      } else {
        Fluttertoast.showToast(
            msg: "Gambar tidak boleh lebih dari 500Kb",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "$e", backgroundColor: Colors.red, textColor: Colors.white);
    }
  }
}
