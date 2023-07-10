import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pesantren_flutter/ui/transaction/model/model_list_transaksi.dart';

import '../../../network/constant.dart';
import '../../../network/repository/authentication_repository.dart';

class ListTransaksiController extends GetxController {
  static ListTransaksiController get to =>
      Get.isRegistered<ListTransaksiController>()
          ? Get.find()
          : Get.put(ListTransaksiController());

  List<History> listHistory = [];
  List<ListTransaksi> listTransaksi = [];
  bool isLoadingHistory = true;
  bool check = true;
  List<String> status = [];
  var req = dio.Dio();

  void getHistory() async {
    try {
      isLoadingHistory = true;
      update();
      String? nis = await AuthenticationRepositoryImpl(req).getNis();
      String? kodeSekolah =
          await AuthenticationRepositoryImpl(req).getKodeSekolah();
      // ignore: unnecessary_brace_in_string_interps
      Map<String, dynamic> mapListTransaksi() {
        return {
          "nis": nis.toString(),
          "kode_sekolah": kodeSekolah.toString(),
          "status": status.toList()
        };
      }

      print(mapListTransaksi());

      var response = await req.post(
          '${Constant.baseUrl}${Constant.listTransaksi}',
          data: mapListTransaksi());

      var res = response.data.runtimeType.toString() == "String"
          ? jsonDecode(response.data)
          : response.data;
      // ignore: avoid_print
      print(res);
      check = res['is_correct'];
      update();
      if (res['is_correct']) {
        final laporanHistory = ListTransaksiModel.fromJson(res);
        listHistory = laporanHistory.history ?? [];
        listTransaksi = laporanHistory.listTransaksi ?? [];
        isLoadingHistory = false;
        update();
      } else {
        isLoadingHistory = false;
        update();
      }
      isLoadingHistory = false;
      update();
    } catch (e) {
      print(e);
    }
  }
}
