class Constant {
  static const int cacheDurationHours = 24;

  static const int successCode = 200;
  static const List<int> clientError = [400, 499];
  static const List<int> serverError = [500, 599];

  static const int readTimeout = 6000;
  static const int writeTimeout = 7000;

  static const String baseUrl = "http://ujipresensi.my.id/flutter/rest_api";
  static const String loginPesantren = "/get_ponpes.php";
  static const String loginStudent = "/get_student.php";
  static const String information = "/informasi.php";
  static const String saving = "/tabungan.php";
  static const String tahfidz = "/tahfidz.php";
  static const String rekamMedis = "/kesehatan.php";
  static const String konseling = "/konseling.php";
}
