import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/lesson_plan.dart';
import '../../../services/gemini_service.dart';

class LessonPlannerController extends GetxController {
  final topicController = TextEditingController();
  final levelController = TextEditingController();
  final durationController = TextEditingController();
  
  final isLoading = false.obs;
  final lessonPlan = LessonPlan.empty().obs;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GeminiService _geminiService = GeminiService();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> generateLessonPlan() async {
    if (topicController.text.isEmpty ||
        levelController.text.isEmpty ||
        durationController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _geminiService.generateLessonPlan(
        topic: topicController.text,
        level: levelController.text,
        duration: int.parse(durationController.text),
      );
      
      // Parse the response into different sections
      final sections = _parseLessonPlanResponse(response);
      
      lessonPlan.value = LessonPlan(
        topic: topicController.text,
        level: levelController.text,
        duration: int.parse(durationController.text),
        preTeaching: sections['Pre-Teaching'] ?? '',
        presentation: sections['Presentation'] ?? '',
        practice: sections['Practice'] ?? '',
        production: sections['Production'] ?? '',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate lesson plan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, String> _parseLessonPlanResponse(String response) {
    final sections = <String, String>{};
    final stages = ['Pre-Teaching', 'Presentation', 'Practice', 'Production'];
    
    for (var i = 0; i < stages.length; i++) {
      final currentStage = stages[i];
      final nextStage = i < stages.length - 1 ? stages[i + 1] : null;
      
      final startIndex = response.indexOf(currentStage);
      final endIndex = nextStage != null 
          ? response.indexOf(nextStage)
          : response.length;
          
      if (startIndex != -1 && endIndex != -1) {
        var content = response.substring(startIndex, endIndex).trim();
        content = content.replaceFirst(currentStage, '').trim();
        sections[currentStage] = content;
      }
    }
    
    return sections;
  }

  Future<void> saveLessonPlan() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('lesson_plans').add({
          'teacher_id': user.uid,
          'topic': lessonPlan.value.topic,
          'level': lessonPlan.value.level,
          'duration': lessonPlan.value.duration,
          'pre_teaching': lessonPlan.value.preTeaching,
          'presentation': lessonPlan.value.presentation,
          'practice': lessonPlan.value.practice,
          'production': lessonPlan.value.production,
          'created_at': FieldValue.serverTimestamp(),
        });
        
        Get.snackbar(
          'Success',
          'Lesson plan saved successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save lesson plan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    topicController.dispose();
    levelController.dispose();
    durationController.dispose();
    super.onClose();
  }
}
