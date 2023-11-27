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
  static const String payments = "/pembayaran2.php";
  static const String presensi = "/presensi.php";
  static const String presensiPelajaran = "/presensi_pelajaran2.php";
  static const String profile = "/profil.php";
  static const String paymentBebas = "/pembayaran_bebas2.php";
  static const String editProfile = "/edit_profil1.php";
  static const String changePassword = "/edit_password.php";
  static const String bayarBebas = "/bayar_tagihan_bebas2.php";
  static const String bayarBulanan = "/bayar_tagihan_bulan2.php";
  static const String listTransaksi = "/list_transaksi.php";
  static const String bayar = "/bayar.php";
  static const String bayarBulanan2 = "/tagihan_bulan_bayar.php";
  static const String bayarBebas2 = "/tagihan_bebas_bayar.php";
  static const String setting = "/setting.php";
  static const String ringkasan = "/ringkasan_pembayaran.php";
  // static const String ipaymu = "/insert_ipaymu.php";
  static const String ipaymu = "/insert_ipaymu_allujicoba.php";
  static const String caraBayar = "/cara_pembayaran.php";
  static const String caraBayarTabungan = "/cara_pembayaran_tabungan.php";
  static const String topupTabungan = "/top_up_tabungan.php";
  static const String unduhTagihan = "/unduh_tagihan.php";
  static const String getOtp = "/get_otp.php";
  static const String veriftOtp = "/verify_otp.php";
  static const String resetPassword = "/reset_password.php";
  static const String konfirmasi = "/info_upload_pembayaran.php";
  static const String tahunAjaran = "/tahun_ajaran.php";
  static const String pelajaran = "/lesson.php";
  static const String uploadBukti = "/upload_bukti_bayar.php";
  static const String detailTransaksi = "/detail_transaksi.php";
  // static const String ipaymu_tabungan = "/insert_ipaymu_tabungan.php";
  static const String ipaymu_tabungan = "/insert_ipaymu_tabunganall.php";
  static const String transaksiTabungan = "/list_transaksi_tabungan.php";
  static const String detailtransaksiTabungan =
      "/detail_transaksi_tabungan.php";
  static const String lesson = "/lesson.php";
  static const String semester = "/semester.php";
  static const String presensiNew = "/presensi_pelajaran2.php";
  static const String penginapan = "/list_homestay.php";
  static const String detailPenginapan = "/detail_homestay.php";
}
