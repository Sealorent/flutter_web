class IzinKeluarParam {
  String? kodeSekolah;
  String? studentNis;
  String? status;
  String? tanggalIzin;
  String? waktuIzin;
  String? keperluanIzin;


  IzinKeluarParam({this.kodeSekolah, this.studentNis, this.status, this.tanggalIzin,
      this.waktuIzin, this.keperluanIzin});

  Map<String, dynamic> toMap() {
    return {
      'kode_sekolah': kodeSekolah,
      'student_nis': studentNis,
      'status': "Diajukan",
      'tanggal_izin': tanggalIzin,
      'waktu_izin': waktuIzin,
      'keperluan_izin': keperluanIzin
    };
  }
}
