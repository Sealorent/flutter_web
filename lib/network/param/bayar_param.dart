class BayarParam {
  String? student_nis;
  String? kode_sekolah;
  String? bayar;
  List<int>? bulan_id;
  List<int>? bebas_id;
  List<int>? bebas_nominal;


  BayarParam({this.student_nis, this.kode_sekolah, this.bayar, this.bulan_id,
      this.bebas_id, this.bebas_nominal});

  Map<String, dynamic> toMap() {
    if(bulan_id == null || bulan_id?.isEmpty == true){
      return {
        'student_nis': student_nis,
        'kode_sekolah': kode_sekolah,
        'bayar' : "Bayar",
        'bulan_id' : [],
        'bebas_id' : bebas_id?.toList() ?? [],
        'bebas_nominal' : bebas_nominal?.toList() ?? []
      };
    }else{
      return {
        'student_nis': student_nis,
        'kode_sekolah': kode_sekolah,
        'bayar' : "Bayar",
        'bulan_id' : bulan_id?.toList() ?? [],
        'bebas_id': [],
        'bebas_nominal': []
      };
    }
  }
}
