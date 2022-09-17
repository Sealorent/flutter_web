import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pesantren_flutter/network/param/edit_profile_param.dart';
import 'package:pesantren_flutter/network/param/izin_pulang_param.dart';
import 'package:pesantren_flutter/network/response/information_response.dart';
import 'package:pesantren_flutter/network/response/izin_response.dart';
import 'package:pesantren_flutter/network/response/konseling_response.dart';
import 'package:pesantren_flutter/network/response/mudif_response.dart';
import 'package:pesantren_flutter/network/response/payment_bebas_response.dart';
import 'package:pesantren_flutter/network/response/payment_response.dart';
import 'package:pesantren_flutter/network/response/pesantren_login_response.dart';
import 'package:pesantren_flutter/network/response/presensi_response.dart';
import 'package:pesantren_flutter/network/response/pulang_response.dart';
import 'package:pesantren_flutter/network/response/rekam_medis_response.dart';
import 'package:pesantren_flutter/network/response/student_login_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';
import 'package:pesantren_flutter/preferences/pref_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../network_exception.dart';
import '../param/izin_keluar_param.dart';
import '../param/login_param.dart';
import '../response/login_response.dart';
import '../response/saving_response.dart';


abstract class MainRepository {
  Future<InformationResponse?> getInformation();
  Future<SavingResponse?> getSavings();
  Future<TahfidzResponse?> getTahfidz();
  Future<RekamMedisResponse?> getRekamMedis();
  Future<KonselingResponse?> getKonseling();
  Future<IzinResponse?> getIzinKeluar();
  Future<PulangResponse?> getIzinPulang();
  Future<MudifResponse?> getMudif();
  Future<Object> postIzinPulang(IzinPulangParam param);
  Future<Object> postIzinKeluar(IzinKeluarParam param);
  Future<PaymentResponse> getPayments();
  Future<PresensiResponse> getPresensi(int bulan);
  Future<PaymentBebasResponse> getPaymentBebas();
}

class MainRepositoryImpl extends MainRepository {
  final Dio _dioClient;

  MainRepositoryImpl(this._dioClient);

  Future<StudentLoginResponse> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var student = prefs.getString(PrefData.student);
    var objectStudent = StudentLoginResponse.fromJson(json.decode(student ?? ""));
    return objectStudent;
  }

  Future<PesantrenLoginResponse> _getPesantren() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pesantren = prefs.getString(PrefData.pesantren);
    var objectpesantren = PesantrenLoginResponse.fromJson(json.decode(pesantren ?? ""));
    return objectpesantren;
  }

  @override
  Future<InformationResponse?> getInformation() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.information, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return InformationResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<SavingResponse?> getSavings() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.saving, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return SavingResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<TahfidzResponse?> getTahfidz() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.tahfidz, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return TahfidzResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<RekamMedisResponse?> getRekamMedis() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.rekamMedis, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return RekamMedisResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<KonselingResponse?> getKonseling() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.konseling, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return KonselingResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<IzinResponse?> getIzinKeluar() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.izinKeluar, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return IzinResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PulangResponse?> getIzinPulang() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.izinPulang, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return PulangResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<MudifResponse?> getMudif() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.mudif, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return MudifResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Object> postIzinPulang(IzinPulangParam param)  async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.studentNis = student.nis;
    param.kodeSekolah = pesantren.kodeSekolah;
    try {
      final response = await _dioClient.post(Constant.addPulang, data: param.toFormData());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return true;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Object> postIzinKeluar(IzinKeluarParam param) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.studentNis = student.nis;
    param.kodeSekolah = pesantren.kodeSekolah;
    try {
      final response = await _dioClient.post(Constant.addIzin, data: param.toFormData());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return true;
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PaymentResponse> getPayments() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.payments, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return PaymentResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PresensiResponse> getPresensi(int bulan) async{
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.presensi, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis,
        "bulan": bulan
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return PresensiResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<PaymentBebasResponse> getPaymentBebas() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.paymentBebas, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return PaymentBebasResponse.fromJson(response.data);
      } else {
        throw ClientErrorException(statusMessage, statusCode);
      }
    } on DioError catch (ex) {
      var statusCode = ex.response?.statusCode ?? -4;
      var statusMessage = ex.message;
      throw ClientErrorException(statusMessage, statusCode);
    } catch (e) {
      throw Exception(e);
    }
  }


}
