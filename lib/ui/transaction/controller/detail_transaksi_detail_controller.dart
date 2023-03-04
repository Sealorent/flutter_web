import 'dart:convert';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

import '../../../network/constant.dart';
import '../../../network/repository/authentication_repository.dart';
import '../model/model_detail_transaksi.dart';

class DetailTransaksiController extends GetxController {
  static DetailTransaksiController get to => Get.isRegistered<DetailTransaksiController>()
      ? Get.find()
      : Get.put(DetailTransaksiController());

  var req = dio.Dio();
  DetailTransaksiModel? dataRingkasan;
  List<Bulan> ringkasanBulan = [];
  List<Bebas> ringkasanBebas = [];
  List<bool> toggleList = [];
  int nominal = 0;
  bool isLoadingMetodeBayar = true;

  void detailTransaksi(String id) async {
    String? nis = await AuthenticationRepositoryImpl(req).getNis();
    String? kodeSekolah = await AuthenticationRepositoryImpl(req).getKodeSekolah();
    Map<String, dynamic> mapDataBatal() {
      return {
        "kode_sekolah": kodeSekolah.toString(),
        "student_nis": nis.toString(),
        "id_transaksi": id,
      };
    }

    var response = await req.post('${Constant.baseUrl}${Constant.detailTransaksi}',
        data: mapDataBatal());
    // Logger().i(response.data);
    var res = response.data.runtimeType.toString() == "String"
        ? jsonDecode(response.data)
        : response.data;
 
    if (res['is_correct']) {
      final ringkasan = DetailTransaksiModel.fromJson(res);
      dataRingkasan = DetailTransaksiModel.fromJson(res);
      ringkasanBulan = ringkasan.bulan ?? [];
      ringkasanBebas = ringkasan.bebas ?? [];
     
      nominal = 0;
      for (var bulanan in ringkasanBulan) {
        nominal += int.parse(bulanan.nominal ?? "0");
      }
      for (var bebas in ringkasanBebas) {
        nominal += int.parse("${bebas.nominal}");
      }
      isLoadingMetodeBayar = false;
      update();
    }
  }
}
