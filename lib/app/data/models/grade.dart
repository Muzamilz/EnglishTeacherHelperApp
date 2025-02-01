import 'package:cloud_firestore/cloud_firestore.dart';

class Grade {
  final String id;
  final String studentName;
  final String component;
  final int score;
  final DateTime date;

  Grade({
    required this.id,
    required this.studentName,
    required this.component,
    required this.score,
    required this.date,
  });

  factory Grade.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Grade(
      id: doc.id,
      studentName: data['student_name'] ?? '',
      component: data['component'] ?? '',
      score: data['score'] ?? 0,
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'student_name': studentName,
      'component': component,
      'score': score,
      'date': Timestamp.fromDate(date),
    };
  }

  Grade copyWith({
    String? id,
    String? studentName,
    String? component,
    int? score,
    DateTime? date,
  }) {
    return Grade(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      component: component ?? this.component,
      score: score ?? this.score,
      date: date ?? this.date,
    );
  }
}
