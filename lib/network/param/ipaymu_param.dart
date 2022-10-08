class IpaymuParam {
  String? student_nis;
  String? kode_sekolah;
  String? noref;
  String? nominal;
  String? payment_channel;
  String? ipaymu_no_trans;


  IpaymuParam({this.student_nis, this.kode_sekolah, this.noref, this.nominal,
      this.payment_channel, this.ipaymu_no_trans});

  bool isValid(){
    return noref != null && nominal != null && payment_channel != null && ipaymu_no_trans != null;
  }

  Map<String, dynamic> toMap() {
      return {
        'student_nis': student_nis,
        'kode_sekolah': kode_sekolah,
        'noref' : noref,
        'nominal' :nominal,
        'payment_channel' : payment_channel,
        'ipaymu_no_trans' : ipaymu_no_trans
      };
  }
}
