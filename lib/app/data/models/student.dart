import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final bool isPresent;
  final int attendanceCount;
  final int totalClasses;

  Student({
    required this.id,
    required this.name,
    required this.isPresent,
    required this.attendanceCount,
    required this.totalClasses,
  });

  double get attendancePercentage =>
      totalClasses > 0 ? (attendanceCount / totalClasses) * 100 : 0;

  factory Student.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      id: doc.id,
      name: data['name'] ?? '',
      isPresent: data['is_present'] ?? false,
      attendanceCount: data['attendance_count'] ?? 0,
      totalClasses: data['total_classes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'is_present': isPresent,
      'attendance_count': attendanceCount,
      'total_classes': totalClasses,
    };
  }

  Student copyWith({
    String? id,
    String? name,
    bool? isPresent,
    int? attendanceCount,
    int? totalClasses,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      isPresent: isPresent ?? this.isPresent,
      attendanceCount: attendanceCount ?? this.attendanceCount,
      totalClasses: totalClasses ?? this.totalClasses,
    );
  }
}
