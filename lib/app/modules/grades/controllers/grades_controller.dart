import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/grade.dart';

class GradesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  final grades = <Grade>[].obs;
  final filteredGrades = <Grade>[].obs;
  final currentFilter = 'All'.obs;
  final gradeDistribution = <double>[0, 0, 0, 0, 0].obs;

  get filterByComponent => null;

  @override
  void onInit() {
    super.onInit();
    loadGrades();
  }

  Future<void> loadGrades() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('grades')
            .where('teacher_id', isEqualTo: user.uid)
            .get();
            
        grades.value = snapshot.docs
            .map((doc) => Grade.fromFirestore(doc))
            .toList();
            
        filterGrades(currentFilter.value);
        updateGradeDistribution();
      }
    } catch (e) {
      print('Error loading grades: $e');
    }
  }

  void filterGrades(String component) {
    currentFilter.value = component;
    if (component == 'All') {
      filteredGrades.value = grades;
    } else {
      filteredGrades.value = grades
          .where((grade) => grade.component == component)
          .toList();
    }
  }

  void updateGradeDistribution() {
    final distribution = List<double>.filled(5, 0);
    final totalGrades = grades.length;

    if (totalGrades > 0) {
      for (final grade in grades) {
        if (grade.score >= 90) {
          distribution[0]++;
        } else if (grade.score >= 80) {
          distribution[1]++;
        } else if (grade.score >= 70) {
          distribution[2]++;
        } else if (grade.score >= 60) {
          distribution[3]++;
        } else {
          distribution[4]++;
        }
      }

      // Convert to percentages
      for (var i = 0; i < distribution.length; i++) {
        distribution[i] = (distribution[i] / totalGrades) * 100;
      }
    }

    gradeDistribution.value = distribution;
  }

  Future<void> addGrade(String studentName, String component, int score) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docRef = await _firestore.collection('grades').add({
          'student_name': studentName,
          'component': component,
          'score': score,
          'teacher_id': user.uid,
          'date': FieldValue.serverTimestamp(),
        });
        
        final grade = Grade(
          id: docRef.id,
          studentName: studentName,
          component: component,
          score: score,
          date: DateTime.now(),
        );
        
        grades.add(grade);
        filterGrades(currentFilter.value);
        updateGradeDistribution();
      }
    } catch (e) {
      print('Error adding grade: $e');
    }
  }

  Future<void> updateGrade(String gradeId, int newScore) async {
    try {
      await _firestore
          .collection('grades')
          .doc(gradeId)
          .update({'score': newScore});
          
      final index = grades.indexWhere((grade) => grade.id == gradeId);
      if (index != -1) {
        final updatedGrade = grades[index].copyWith(score: newScore);
        grades[index] = updatedGrade;
        filterGrades(currentFilter.value);
        updateGradeDistribution();
      }
    } catch (e) {
      print('Error updating grade: $e');
    }
  }
}
