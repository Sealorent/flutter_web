import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class EditProfileParam {
  String? student_nis;
  String? kode_sekolah;
  String? nama_santri;
  String? alamat;
  String? tempatlahir;
  String? tanggallahir;
  String? nomorwa;
  String? gender;
  String? ayah;
  String? ibu;
  File? student_img;

  EditProfileParam(
      {this.student_nis,
      this.kode_sekolah,
      this.nama_santri,
      this.alamat,
      this.tempatlahir,
      this.tanggallahir,
      this.nomorwa,
      this.gender,
      this.ayah,
      this.ibu,
      this.student_img});

  Future<FormData?> toFormData() async {
    if (student_img == null) {
      return FormData.fromMap({
        'student_nis': student_nis,
        'kode_sekolah': kode_sekolah,
        'nama_santri': nama_santri,
        'alamat': alamat,
        'tempatlahir': tempatlahir,
        'tanggallahir': tanggallahir,
        'nomorwa': nomorwa,
        'gender': gender,
        'ayah': ayah,
        'ibu': ibu,
      });
    } else {
      return FormData.fromMap({
        'student_nis': student_nis,
        'kode_sekolah': kode_sekolah,
        'nama_santri': nama_santri,
        'alamat': alamat,
        'tempatlahir': tempatlahir,
        'tanggallahir': tanggallahir,
        'nomorwa': nomorwa,
        'gender': gender,
        'ayah': ayah,
        'ibu': ibu,
        'student_img': await MultipartFile.fromFile(student_img!.path,
            filename:
                '$nama_santri${DateFormat("HH:mm:ss").format(DateTime.now())}')
      });
    }
  }
}
