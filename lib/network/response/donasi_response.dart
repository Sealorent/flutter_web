class DonasiResponse {
  bool isCorrect;
  dynamic laporan;
  String message;

  DonasiResponse({
    required this.isCorrect,
    required this.laporan,
    required this.message,
  });

  factory DonasiResponse.fromJson(Map<String, dynamic> json) {

    return DonasiResponse(
      isCorrect: json['is_correct'],
      laporan: json['laporan'],
      message: json['message'],
    );
    
  }
}

class DataDonasiCategory{
  int categoryId;
  String categoryName;
  String categoryDesc;

  DataDonasiCategory({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDesc,
  });

  factory DataDonasiCategory.fromJson(Map<String, dynamic> json) {
    return DataDonasiCategory(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      categoryDesc: json['category_desc'],
    );
  }
}


class DataDonasi{
  int donasiId;
  String donasiTitle;
  String donasiDesc;
  String donasiImage;
  String donasiStartDate;
  String donasiEndDate;
  int donasiTarget;
  int donasiCategoryId;

  DataDonasi({
    required this.donasiId,
    required this.donasiTitle,
    required this.donasiDesc,
    required this.donasiImage,
    required this.donasiStartDate,
    required this.donasiEndDate,
    required this.donasiTarget,
    required this.donasiCategoryId,
  });

  factory DataDonasi.fromJson(Map<String, dynamic> json) {
    return DataDonasi(
      donasiId: json['donasi_id'],
      donasiTitle: json['donasi_title'],
      donasiDesc: json['donasi_desc'],
      donasiImage: json['donasi_image'],
      donasiStartDate: json['donasi_start_date'],
      donasiEndDate: json['donasi_end_date'],
      donasiTarget: json['donasi_target'],
      donasiCategoryId: json['donasi_category_id'],
    );
  }
}