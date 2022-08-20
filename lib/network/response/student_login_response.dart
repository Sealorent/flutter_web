// To parse this JSON data, do
//
//     final studentLoginResponse = studentLoginResponseFromJson(jsonString);

import 'dart:convert';

StudentLoginResponse studentLoginResponseFromJson(String str) => StudentLoginResponse.fromJson(json.decode(str));

String studentLoginResponseToJson(StudentLoginResponse data) => json.encode(data.toJson());

class StudentLoginResponse {
  StudentLoginResponse({
    this.isCorrect,
    this.username,
    this.nama,
    this.nis,
    this.phone,
    this.ibu,
    this.ayah,
    this.gender,
    this.tempatlahir,
    this.tanggallahir,
    this.kelasId,
    this.kelas,
    this.majorsId,
    this.majors,
    this.majorsShortName,
    this.photo,
    this.message,
  });

  bool? isCorrect;
  String? username;
  String? nama;
  String? nis;
  String? phone;
  String? ibu;
  String? ayah;
  String? gender;
  String? tempatlahir;
  DateTime? tanggallahir;
  String? kelasId;
  String? kelas;
  String? majorsId;
  String? majors;
  String? majorsShortName;
  String? photo;
  String? message;

  factory StudentLoginResponse.fromJson(Map<String, dynamic> json) => StudentLoginResponse(
    isCorrect: json["is_correct"],
    username: json["username"],
    nama: json["nama"],
    nis: json["nis"],
    phone: json["phone"],
    ibu: json["ibu"],
    ayah: json["ayah"],
    gender: json["gender"],
    tempatlahir: json["tempatlahir"],
    tanggallahir: DateTime.parse(json["tanggallahir"]),
    kelasId: json["kelas_id"],
    kelas: json["kelas"],
    majorsId: json["majors_id"],
    majors: json["majors"],
    majorsShortName: json["majors_short_name"],
    photo: json["photo"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "is_correct": isCorrect,
    "username": username,
    "nama": nama,
    "nis": nis,
    "phone": phone,
    "ibu": ibu,
    "ayah": ayah,
    "gender": gender,
    "tempatlahir": tempatlahir,
    "tanggallahir": "${tanggallahir?.year.toString().padLeft(4, '0')}-${tanggallahir?.month.toString().padLeft(2, '0')}-${tanggallahir?.day.toString().padLeft(2, '0')}",
    "kelas_id": kelasId,
    "kelas": kelas,
    "majors_id": majorsId,
    "majors": majors,
    "majors_short_name": majorsShortName,
    "photo": photo,
    "message": message,
  };
}
