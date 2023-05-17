import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

import '../../../network/constant.dart';
import '../../../network/repository/authentication_repository.dart';

class ListTransaksiTabunganController extends GetxController {
  static ListTransaksiTabunganController get to =>
      Get.isRegistered<ListTransaksiTabunganController>()
          ? Get.find()
          : Get.put(ListTransaksiTabunganController());
}