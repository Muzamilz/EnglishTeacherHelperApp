import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/class_info.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final teacherName = 'Teacher'.obs;
  final totalStudents = 0.obs;
  final averageAttendance = 0.0.obs;
  final upcomingClasses = <ClassInfo>[].obs;
  final currentThemeMode = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTeacherData();
    loadStatistics();
    loadUpcomingClasses();
  }

  Future<void> loadTeacherData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final teacherDoc = await _firestore
            .collection('teachers')
            .doc(user.uid)
            .get();
        
        if (teacherDoc.exists) {
          teacherName.value = teacherDoc.data()?['name'] ?? 'Teacher';
        }
      }
    } catch (e) {
      print('Error loading teacher data: $e');
    }
  }

  Future<void> loadStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final statsDoc = await _firestore
            .collection('statistics')
            .doc(user.uid)
            .get();
        
        if (statsDoc.exists) {
          totalStudents.value = statsDoc.data()?['total_students'] ?? 0;
          averageAttendance.value = statsDoc.data()?['average_attendance'] ?? 0.0;
        }
      }
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> loadUpcomingClasses() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final now = DateTime.now();
        final classes = await _firestore
            .collection('classes')
            .where('teacher_id', isEqualTo: user.uid)
            .where('date', isGreaterThanOrEqualTo: now)
            .orderBy('date')
            .limit(5)
            .get();
        
        upcomingClasses.value = classes.docs
            .map((doc) => ClassInfo.fromFirestore(doc))
            .toList();
      }
    } catch (e) {
      print('Error loading upcoming classes: $e');
    }
  }

  void changeTheme() {
    currentThemeMode.value = (currentThemeMode.value + 1) % 4;
    switch (currentThemeMode.value) {
      case 0:
        Get.changeThemeMode(ThemeMode.light);
        break;
      case 1:
        Get.changeThemeMode(ThemeMode.dark);
        break;
      case 2:
        // Sepia theme
        break;
      case 3:
        // Nature theme
        break;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
