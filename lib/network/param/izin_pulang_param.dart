class IzinPulangParam {
  String? kodeSekolah;
  String? studentNis;
  String? status;
  String? tanggalPulang;
  String? hariPulang;
  String? keperluanPulang;


  IzinPulangParam({this.kodeSekolah, this.studentNis, this.status, this.tanggalPulang,
      this.hariPulang, this.keperluanPulang});

  Map<String, dynamic> toMap() {
    return {
      'kode_sekolah': kodeSekolah,
      'student_nis': studentNis,
      'status': status,
      'tanggal_pulang': tanggalPulang,
      'hari_pulang': hariPulang,
      'keperluan_pulang': keperluanPulang
    };
  }
}
