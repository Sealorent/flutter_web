import 'package:dio/dio.dart';

class TopUpTabunganParam {
  String? student_nis;
  String? kode_sekolah;
  String? nominal;
  String? catatan;

  TopUpTabunganParam(
      {this.student_nis, this.kode_sekolah, this.nominal, this.catatan});

  FormData? toFormData() {
    return FormData.fromMap({
      'nis': student_nis,
      'kode_sekolah': kode_sekolah,
      'nominal': nominal,
      "bayar": "Bayar",
      'catatan': catatan
    });
  }

  Map<String,dynamic> toMap(){
    return {
      'nis': student_nis,
      'kode_sekolah': kode_sekolah,
      'nominal': nominal,
      "bayar": "Bayar",
      'catatan': catatan
    };
  }

  bool isValid() {
    return nominal?.isNotEmpty == true;
  }
}
