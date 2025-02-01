import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/student.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final students = <Student>[].obs;
  final attendanceData = <FlSpot>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadStudents();
    loadAttendanceData();
  }

  Future<void> loadStudents() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('students')
            .where('teacher_id', isEqualTo: user.uid)
            .get();
            
        students.value = snapshot.docs
            .map((doc) => Student.fromFirestore(doc))
            .toList();
      }
    } catch (e) {
      print('Error loading students: $e');
    }
  }

  Future<void> loadAttendanceData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final now = DateTime.now();
        final sevenDaysAgo = now.subtract(const Duration(days: 7));
        
        final snapshot = await _firestore
            .collection('attendance')
            .where('teacher_id', isEqualTo: user.uid)
            .where('date', isGreaterThanOrEqualTo: sevenDaysAgo)
            .orderBy('date')
            .get();
            
        final data = snapshot.docs.map((doc) {
          final data = doc.data();
          final date = (data['date'] as Timestamp).toDate();
          final presentCount = data['present_count'] as int;
          final totalCount = data['total_count'] as int;
          final percentage = totalCount > 0 ? (presentCount / totalCount) * 100 : 0.0;
          
          return MapEntry(
            date.difference(sevenDaysAgo).inDays.toDouble(),
            percentage,
          );
        }).toList();
        
        attendanceData.value = data
            .map((entry) => FlSpot(entry.key, entry.value))
            .toList();
      }
    } catch (e) {
      print('Error loading attendance data: $e');
    }
  }

  String getDateLabel(int dayOffset) {
    final date = DateTime.now().subtract(Duration(days: 7 - dayOffset));
    return DateFormat('MM/dd').format(date);
  }

  Future<void> toggleAttendance(int index, bool value) async {
    try {
      final student = students[index];
      final updatedStudent = student.copyWith(isPresent: value);
      students[index] = updatedStudent;
      
      await _firestore
          .collection('students')
          .doc(student.id)
          .update({'is_present': value});
          
      await _updateAttendanceRecord();
    } catch (e) {
      print('Error updating attendance: $e');
    }
  }

  Future<void> markAllPresent() async {
    try {
      for (var i = 0; i < students.length; i++) {
        await toggleAttendance(i, true);
      }
    } catch (e) {
      print('Error marking all present: $e');
    }
  }

  Future<void> addStudent(String name) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docRef = await _firestore.collection('students').add({
          'name': name,
          'teacher_id': user.uid,
          'is_present': false,
          'attendance_count': 0,
          'total_classes': 0,
        });
        
        final student = Student(
          id: docRef.id,
          name: name,
          isPresent: false,
          attendanceCount: 0,
          totalClasses: 0,
        );
        
        students.add(student);
      }
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> _updateAttendanceRecord() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        
        final presentCount = students.where((s) => s.isPresent).length;
        final totalCount = students.length;
        
        await _firestore.collection('attendance').add({
          'teacher_id': user.uid,
          'date': today,
          'present_count': presentCount,
          'total_count': totalCount,
        });
        
        await loadAttendanceData();
      }
    } catch (e) {
      print('Error updating attendance record: $e');
    }
  }
}
