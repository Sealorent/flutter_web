import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pesantren_flutter/network/param/bayar_param.dart';
import 'package:pesantren_flutter/network/param/edit_profile_param.dart';
import 'package:pesantren_flutter/network/param/ipaymu_param.dart';
import 'package:pesantren_flutter/network/param/izin_pulang_param.dart';
import 'package:pesantren_flutter/network/response/base_response.dart';
import 'package:pesantren_flutter/network/response/bayar_response.dart';
import 'package:pesantren_flutter/network/response/history_response.dart';
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
import 'package:pesantren_flutter/network/response/ringkasan_response.dart';
import 'package:pesantren_flutter/network/response/student_login_response.dart';
import 'package:pesantren_flutter/network/response/tahfidz_response.dart';
import 'package:pesantren_flutter/network/response/top_up_tabungan_response.dart';
import 'package:pesantren_flutter/preferences/pref_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../network_exception.dart';
import '../param/izin_keluar_param.dart';
import '../param/login_param.dart';
import '../param/top_up_tabungan_param.dart';
import '../response/bayar_bebas_response.dart';
import '../response/bayar_bulanan_response.dart';
import '../response/cara_pembayaran_response.dart';
import '../response/login_response.dart';
import '../response/saving_response.dart';
import '../response/setting_response.dart';
import '../response/tahun_ajaran_response.dart';


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
  Future<PaymentResponse> getPayments(List<int> periodIds);
  Future<PresensiResponse> getPresensi(int bulan);
  Future<PaymentBebasResponse> getPaymentBebas(List<int> periodIds);
  Future<BayarBulananResponse> getBayarBulanan();
  Future<BayarBebasResponse> getBayarBebas();
  Future<HistoryResponse> getHistory();
  Future<BayarResponse> bayar(BayarParam param);
  Future<RingkasanResponse> getRingkasan(String noIpayMu);
  Future<Object> insertIpaymu(IpaymuParam param);
  Future<CaraPembayaranResponse> getCaraPemabayaran(IpaymuParam param);
  Future<TopUpTabunganResponse> topUpTabungan(TopUpTabunganParam param);
  Future<BaseResponse> unduhTagihan();
  Future<TahunAjaranResponse> getTahunAjaran();
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
  Future<PaymentResponse> getPayments(List<int> periodIds) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.post(Constant.payments, data: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis,
        "period_id": periodIds.toList()
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
  Future<PaymentBebasResponse> getPaymentBebas(List<int> periodIds) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.post(Constant.paymentBebas, data: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis,
        "period_id": periodIds.toList()
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

  @override
  Future<BayarBulananResponse> getBayarBulanan() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.post(Constant.bayarBulanan, data: FormData.fromMap({
        "kode_sekolah" : pesantren.kodeSekolah,
        "student_nis": student.nis
      }));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return BayarBulananResponse.fromJson(response.data);
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
  Future<BayarBebasResponse> getBayarBebas() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.post(Constant.bayarBebas, data: FormData.fromMap({
        "kode_sekolah" : pesantren.kodeSekolah,
        "student_nis": student.nis
      }));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return BayarBebasResponse.fromJson(response.data);
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
  Future<HistoryResponse> getHistory() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.history, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return HistoryResponse.fromJson(response.data);
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
  Future<TopUpTabunganResponse> topUpTabungan(TopUpTabunganParam param) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.student_nis = student.nis;
    param.kode_sekolah = pesantren.kodeSekolah;
    try {
      final response = await _dioClient.post(Constant.topupTabungan, data: param.toFormData());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var res = TopUpTabunganResponse.fromJson(response.data);
        if(res.isCorrect == true){
          return res;
        }else{
          throw ClientErrorException(statusMessage, statusCode);
        }
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
  Future<CaraPembayaranResponse> getCaraPemabayaran(IpaymuParam param) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.student_nis = student.nis;
    param.kode_sekolah = pesantren.kodeSekolah;
    try {
      final response = await _dioClient.post(Constant.caraBayar, data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        var res = CaraPembayaranResponse.fromJson(response.data);
        if(res.isCorrect == true){
          return res;
        }else{
          throw ClientErrorException(statusMessage, statusCode);
        }
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
  Future<Object> insertIpaymu(IpaymuParam param) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.student_nis = student.nis;
    param.kode_sekolah = pesantren.kodeSekolah;
    try {
      final response = await _dioClient.post(Constant.ipaymu, data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        // var res = BaseResponse.fromJson(response.data);
        // if(res.isCorrect == true){
        //   return res;
        // }else{
        //   throw ClientErrorException(statusMessage, statusCode);
        // }

        return true;
      } else {
        print("gilang1112");
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
  Future<BayarResponse> bayar(BayarParam param) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    param.student_nis = student.nis;
    param.kode_sekolah = pesantren.kodeSekolah;
    try {
      final response = await _dioClient.post(Constant.bayar, data: param.toMap());
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return BayarResponse.fromJson(response.data);
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
  Future<RingkasanResponse> getRingkasan(String noIpayMu) async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.post(Constant.ringkasan, data: FormData.fromMap({
        "kode_sekolah" : pesantren.kodeSekolah,
        "student_nis": student.nis,
        "ipaymu_no_trans": noIpayMu
      }));
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return RingkasanResponse.fromJson(response.data);
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
  Future<BaseResponse> unduhTagihan() async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.unduhTagihan, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return BaseResponse.fromJson(response.data);
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
  Future<TahunAjaranResponse> getTahunAjaran()  async {
    var student = await _getUser();
    var pesantren = await _getPesantren();
    try {
      final response = await _dioClient.get(Constant.tahunAjaran, queryParameters: {
        "kode_sekolah" : pesantren.kodeSekolah,
        "nis": student.nis
      });
      var statusCode = response.statusCode ?? -1;
      var statusMessage = response.statusMessage ?? "Unknown Error";
      if (statusCode == Constant.successCode) {
        return TahunAjaranResponse.fromJson(response.data);
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
