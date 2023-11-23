class Lesson {
  String id;
  String lessonCode;
  String lessonName;

  Lesson({
    required this.id,
    required this.lessonCode,
    required this.lessonName,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => Lesson(
        id: json['id'],
        lessonCode: json['lesson_code'],
        lessonName: json['lesson_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'lesson_code': lessonCode,
        'lesson_name': lessonName,
      };
}

class LessonResponse {
  bool? isCorrect;
  List<Lesson>? lessons;
  String? message;

  LessonResponse({
    required this.isCorrect,
    required this.lessons,
    required this.message,
  });

  factory LessonResponse.fromJson(Map<String, dynamic> json) => LessonResponse(
        isCorrect: json['is_correct'],
        lessons: (json['pelajaran'] as List)
            .map((lesson) => Lesson.fromJson(lesson))
            .toList(),
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'is_correct': isCorrect,
        'pelajaran': lessons?.map((lesson) => lesson.toJson()).toList(),
        'message': message,
      };
}

