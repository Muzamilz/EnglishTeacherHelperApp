import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ClassInfo {
  final String id;
  final String className;
  final DateTime date;
  final int durationMinutes;
  final String teacherId;

  ClassInfo({
    required this.id,
    required this.className,
    required this.date,
    required this.durationMinutes,
    required this.teacherId,
  });

  String get time => DateFormat('HH:mm').format(date);
  String get duration => '$durationMinutes mins';

  factory ClassInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClassInfo(
      id: doc.id,
      className: data['class_name'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      durationMinutes: data['duration_minutes'] ?? 0,
      teacherId: data['teacher_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'class_name': className,
      'date': Timestamp.fromDate(date),
      'duration_minutes': durationMinutes,
      'teacher_id': teacherId,
    };
  }
}
