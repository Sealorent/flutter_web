class VerifyOtpModel {
  bool? isCorrect;
  String? kodeSekolah;
  String? nis;
  String? message;

  VerifyOtpModel({this.isCorrect, this.kodeSekolah, this.nis, this.message});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    isCorrect = json['is_correct'];
    kodeSekolah = json['kode_sekolah'];
    nis = json['nis'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_correct'] = isCorrect;
    data['kode_sekolah'] = kodeSekolah;
    data['nis'] = nis;
    data['message'] = message;
    return data;
  }
}
