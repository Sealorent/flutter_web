class GetOtpModel {
  bool? isCorrect;
  String? kodeSekolah;
  String? nis;
  String? secret;
  String? message;

  GetOtpModel(
      {this.isCorrect, this.kodeSekolah, this.nis, this.secret, this.message});

  GetOtpModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    kodeSekolah = json['kode_sekolah'];
    nis = json['nis'];
    secret = json['secret'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_correct'] = isCorrect;
    data['kode_sekolah'] = kodeSekolah;
    data['nis'] = nis;
    data['secret'] = secret;
    data['message'] = message;
    return data;
  }
}
