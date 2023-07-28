// To parse this JSON data, do
//
//     final studentLoginResponse = studentLoginResponseFromJson(jsonString);

import 'dart:convert';

StudentLoginResponse studentLoginResponseFromJson(String str) =>
    StudentLoginResponse.fromJson(json.decode(str));

String studentLoginResponseToJson(StudentLoginResponse data) =>
    json.encode(data.toJson());

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
    // ignore: non_constant_identifier_names
    this.student_madin,
    this.tempatlahir,
    this.tanggallahir,
    this.kelasId,
    this.kelas,
    this.majorsId,
    this.majors,
    this.majorsShortName,
    this.photo,
    this.message,
    this.navmenu,
  });

  bool? isCorrect;
  String? username;
  String? nama;
  String? nis;
  String? phone;
  String? ibu;
  String? ayah;
  String? gender;
  // ignore: non_constant_identifier_names
  String? student_madin;
  String? tempatlahir;
  DateTime? tanggallahir;
  String? kelasId;
  String? kelas;
  String? majorsId;
  String? majors;
  String? majorsShortName;
  String? photo;
  String? message;
  List<NavMenu>? navmenu;

  factory StudentLoginResponse.fromJson(Map<String, dynamic> json) =>
      StudentLoginResponse(
        isCorrect: json["is_correct"],
        username: json["username"],
        nama: json["nama"],
        nis: json["nis"],
        phone: json["phone"],
        ibu: json["ibu"],
        ayah: json["ayah"],
        gender: json["gender"] ?? json["student_gender"],
        student_madin: json["student_madin"] ?? json["student_madin"],
        tempatlahir: json["tempatlahir"] ?? json["student_born_place"],
        tanggallahir: (json["tanggallahir"] == null
                ? null
                : DateTime.tryParse(json["tanggallahir"])) ??
            (json["student_born_date"] == null
                ? null
                : DateTime.tryParse(json["student_born_date"])),
        kelasId: json["kelas_id"] ?? json["class_id"],
        kelas: json["kelas"] ?? json["class_name"],
        majorsId: json["majors_id"],
        majors: json["majors"] ?? json["majors_name"],
        majorsShortName: json["majors_short_name"] ?? json["majors_s_name"],
        photo: json["photo"] ?? json["student_img"],
        message: json["message"],
        navmenu:
            List<NavMenu>.from(json["navmenu"].map((x) => NavMenu.fromJson(x))),
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
        "student_madin": student_madin,
        "tempatlahir": tempatlahir,
        "tanggallahir":
            "${tanggallahir?.year.toString().padLeft(4, '0')}-${tanggallahir?.month.toString().padLeft(2, '0')}-${tanggallahir?.day.toString().padLeft(2, '0')}",
        "kelas_id": kelasId,
        "kelas": kelas,
        "majors_id": majorsId,
        "majors": majors,
        "majors_short_name": majorsShortName,
        "photo": photo,
        "message": message,
        "navmenu": List<dynamic>.from(navmenu?.map((x) => x.toJson()) ?? []),
      };
}

class NavMenu {
  NavMenu({
    this.name,
    this.icon,
  });

  String? name;
  String? icon;

  factory NavMenu.fromJson(Map<String, dynamic> json) => NavMenu(
        name: json["name"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "icon": icon,
      };
}
