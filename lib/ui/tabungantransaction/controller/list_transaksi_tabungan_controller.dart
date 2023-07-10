import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:pesantren_flutter/ui/tabungantransaction/model/model_list_transaksi_tabungan.dart';

import '../../../network/constant.dart';
import '../../../network/repository/authentication_repository.dart';

class ListTransaksiTabunganController extends GetxController {
  static ListTransaksiTabunganController get to =>
      Get.isRegistered<ListTransaksiTabunganController>()
          ? Get.find()
          : Get.put(ListTransaksiTabunganController());

  // List<History> listHistory = [];
  PaginationResponse? paginationResponse;
  List<ListTransaksiTabungan> listTransaksiTabungan = [];
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
      Map<String, dynamic> mapList() {
        return {
          "nis": nis.toString(),
          "kode_sekolah": kodeSekolah.toString(),
          "status": ["PENDING", "LUNAS", "EXPIRED"]
        };
      }

      var response = await req.post(
          '${Constant.baseUrl}${Constant.transaksiTabungan}',
          data: mapList());

      var res = response.data.runtimeType.toString() == "String"
          ? jsonDecode(response.data)
          : response.data;
      // ignore: avoid_print
      check = res['is_correct'];
      update();
      if (res['is_correct']) {
        final list = ListTransaksiTabunganModel.fromJson(res);
        listTransaksiTabungan = list.listTransaksiTabungan ?? [];
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

  void _onLoading() async {
    paginationResponse = paginateList(listTransaksiTabungan, 2, 2);
    // lastPage = (_listTransaksiTabunganResponse!.length / 2).round();

    // if (page > lastPage) {
    //   endPage = true;
    //   setState(() {});
    // } else {
    //   page = page + 1;
    //   paginationResponse =
    //       paginateList(_listTransaksiTabunganResponse, page, 2);
    //   _listTransaksiPaginate.addAll(paginationResponse!.data!.toList());
    //   setState(() {});
    // }
    // _refreshController.loadComplete();
  }
}
