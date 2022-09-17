class Constant {
  static const int cacheDurationHours = 24;

  static const int successCode = 200;
  static const List<int> clientError = [400, 499];
  static const List<int> serverError = [500, 599];

  static const int readTimeout = 6000;
  static const int writeTimeout = 7000;
  // 2203007&nis=10025
  // static const String baseUrl = "http://ujipresensi.my.id/flutter/rest_api";
  // Id pesantren 2012008
  // Id santri 10025
  // Pass 123456
  static const String baseUrl = "https://mobile.epesantren.co.id/walsan";
  static const String loginPesantren = "/get_ponpes.php";
  static const String loginStudent = "/get_student.php";
  static const String information = "/informasi.php";
  static const String saving = "/tabungan.php";
  static const String tahfidz = "/tahfidz.php";
  static const String rekamMedis = "/kesehatan.php";
  static const String konseling = "/konseling.php";
  static const String izinKeluar = "/izin.php";
  static const String izinPulang = "/pulang.php";
  static const String mudif = "/mudif.php";
  static const String addIzin = "/add_izin.php";
  static const String addPulang = "/add_pulang.php";
  static const String payments = "/pembayaran.php";
  static const String presensi = "/presensi.php";
  static const String paymentBebas = "/pembayaran_bebas.php";
  static const String editProfile = "/edit_profil.php";
}
