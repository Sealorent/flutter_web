import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:pesantren_flutter/ui/tabungantransaction/model/model_detail_transaksi_tabungan.dart';

import '../../../network/constant.dart';
import '../../../network/repository/authentication_repository.dart';

class DetailTransaksiTabunganController extends GetxController {
  static DetailTransaksiTabunganController get to =>
      Get.isRegistered<DetailTransaksiTabunganController>()
          ? Get.find()
          : Get.put(DetailTransaksiTabunganController());

  var req = dio.Dio();
  DetailTransaksiTabunganModel? data;
  int nominal = 0;
  bool isLoading = true;

  void detailTransaksi(String id) async {
    String? nis = await AuthenticationRepositoryImpl(req).getNis();
    String? kodeSekolah =
        await AuthenticationRepositoryImpl(req).getKodeSekolah();
    Map<String, dynamic> mapDataBatal() {
      return {
        "kode_sekolah": kodeSekolah.toString(),
        "student_nis": nis.toString(),
        "id_transaksi": id,
      };
    }

    var response = await req.post(
        '${Constant.baseUrl}${Constant.detailtransaksiTabungan}',
        data: mapDataBatal());
    // Logger().i(response.data);
    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;
    print(mapDataBatal());
    print(res);
    if (res['is_correct']) {
      data = DetailTransaksiTabunganModel.fromJson(res);
      isLoading = false;
      update();
    }
  }
}
