class SemesterResponse {
  bool isCorrect;
  List<Semester> semester;
  String message;

  SemesterResponse({
    required this.isCorrect,
    required this.semester,
    required this.message,
  });

  factory SemesterResponse.fromJson(Map<String, dynamic> json) {
    return SemesterResponse(
      isCorrect: json['is_correct'],
      semester: (json['semester'] as List)
          .map((semesterJson) => Semester.fromJson(semesterJson))
          .toList(),
      message: json['message'],
    );
  }
}

class Semester {
  String id;
  String semester;

  Semester({
    required this.id,
    required this.semester,
  });

  factory Semester.fromJson(Map<String, dynamic> json) {
    return Semester(
      id: json['id'],
      semester: json['semester'],
    );
  }
}