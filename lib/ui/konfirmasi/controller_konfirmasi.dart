import 'dart:convert';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pesantren_flutter/network/constant.dart';
import 'package:pesantren_flutter/network/repository/authentication_repository.dart';
import 'package:pesantren_flutter/ui/konfirmasi/model_konfirmasi.dart';

class KonfirmasiController extends GetxController {
  static KonfirmasiController get to => Get.isRegistered<KonfirmasiController>()
      ? Get.find()
      : Get.put(KonfirmasiController());
  List<Upload> listKonfirmasi = [];
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
        listKonfirmasi = konfirmasiData.upload ?? [];
      }
    } catch (e) {
      print(e);
    }
  }
}
