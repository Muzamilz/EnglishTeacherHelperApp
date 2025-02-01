import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lesson_planner_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LessonPlannerView extends GetView<LessonPlannerController> {
  const LessonPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Planner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLessonInputSection(context),
            const SizedBox(height: 24),
            _buildGeneratedPlanSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonInputSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Plan Your Lesson',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.topicController,
              decoration: InputDecoration(
                labelText: 'Lesson Topic',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().fadeIn().slideX(),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.levelController,
              decoration: InputDecoration(
                labelText: 'Student Level',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().fadeIn().slideX(),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.durationController,
              decoration: InputDecoration(
                labelText: 'Lesson Duration (minutes)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixText: 'mins',
              ),
              keyboardType: TextInputType.number,
            ).animate().fadeIn().slideX(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.generateLessonPlan,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate Lesson Plan'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ).animate().fadeIn().scale(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedPlanSection(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? const Center(child: CircularProgressIndicator())
        : controller.lessonPlan.value.isNotEmpty
            ? Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Generated Lesson Plan',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          IconButton(
                            icon: const Icon(Icons.save),
                            onPressed: controller.saveLessonPlan,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildLessonStage(
                        context,
                        'Pre-Teaching',
                        controller.lessonPlan.value.preTeaching,
                      ),
                      _buildLessonStage(
                        context,
                        'Presentation',
                        controller.lessonPlan.value.presentation,
                      ),
                      _buildLessonStage(
                        context,
                        'Practice',
                        controller.lessonPlan.value.practice,
                      ),
                      _buildLessonStage(
                        context,
                        'Production',
                        controller.lessonPlan.value.production,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn().slideY()
            : const SizedBox());
  }

  Widget _buildLessonStage(
    BuildContext context,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Divider(height: 32),
      ],
    );
  }
}
