class PresensiResponseNew {
  bool isCorrect;
  String username;
  String nama;
  String nis;
  dynamic laporan;
  String message;

  PresensiResponseNew({
    required this.isCorrect,
    required this.username,
    required this.nama,
    required this.nis,
    required this.laporan,
    required this.message,
  });

  factory PresensiResponseNew.fromJson(Map<String, dynamic> json) {

    dynamic laporanJson = json['laporan'];

    List<LaporanNew> laporanList;
    if (laporanJson is List) {
      laporanList = laporanJson.map((laporanJson) => LaporanNew.fromJson(laporanJson)).toList();

      return PresensiResponseNew(
        isCorrect: json['is_correct'],
        username: json['username'],
        nama: json['nama'],
        nis: json['nis'],
        laporan: laporanList,
        message: json['message'],
      );
    } else {
      // If 'laporan' is not a List, handle it as a string message
      return PresensiResponseNew(
        isCorrect: json['is_correct'],
        username: 'gatut',
        nama: 'gatut',
        nis: '123',
        laporan: laporanJson,
        message: json['message'],
      );
    }
   

    
  }
}

class LaporanNew {
  Detail detail;

  LaporanNew({
    required this.detail,
  });

  factory LaporanNew.fromJson(Map<String, dynamic> json) {
    return LaporanNew(
      detail: Detail.fromJson(json['detail']),
    );
  }
}

class Detail {
  String tanggal;
  String kehadiran;
  String pelajaran;

  Detail({
    required this.tanggal,
    required this.kehadiran,
    required this.pelajaran,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      tanggal: json['tanggal'],
      kehadiran: json['kehadiran'],
      pelajaran: json['pelajaran'],
    );
  }
}


class PresensiNull {
  bool isCorrect;
  String laporan;
  String message;

  PresensiNull({
    required this.isCorrect,
    required this.laporan,
    required this.message,
  });

  factory PresensiNull.fromJson(Map<String, dynamic> json) {
    return PresensiNull(
      isCorrect: json['is_correct'],
      laporan: json['laporan'],
      message: json['message'],
    );
  }
}