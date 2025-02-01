class LessonPlan {
  final String topic;
  final String level;
  final int duration;
  final String preTeaching;
  final String presentation;
  final String practice;
  final String production;

  LessonPlan({
    required this.topic,
    required this.level,
    required this.duration,
    required this.preTeaching,
    required this.presentation,
    required this.practice,
    required this.production,
  });

  factory LessonPlan.empty() {
    return LessonPlan(
      topic: '',
      level: '',
      duration: 0,
      preTeaching: '',
      presentation: '',
      practice: '',
      production: '',
    );
  }

  factory LessonPlan.fromMap(Map<String, dynamic> map) {
    return LessonPlan(
      topic: map['topic'] ?? '',
      level: map['level'] ?? '',
      duration: map['duration'] ?? 0,
      preTeaching: map['pre_teaching'] ?? '',
      presentation: map['presentation'] ?? '',
      practice: map['practice'] ?? '',
      production: map['production'] ?? '',
    );
  }

  get isNotEmpty => null;

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'level': level,
      'duration': duration,
      'pre_teaching': preTeaching,
      'presentation': presentation,
      'practice': practice,
      'production': production,
    };
  }
}
