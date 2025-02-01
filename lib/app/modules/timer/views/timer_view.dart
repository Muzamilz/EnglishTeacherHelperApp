import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/timer_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TimerView extends GetView<TimerController> {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Timer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMainTimer(context),
            const SizedBox(height: 24),
            _buildStageTimers(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTimer(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Class Timer',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
              controller.mainTimeDisplay.value,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: controller.getTimeColor(),
              ),
            )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.setMainTimer(),
                  child: const Text('Set Time'),
                ),
                const SizedBox(width: 16),
                Obx(() => ElevatedButton(
                  onPressed: controller.toggleMainTimer,
                  child: Text(controller.isMainRunning.value ? 'Pause' : 'Start'),
                )),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: controller.resetMainTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildStageTimers(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Lesson Stages',
          style: Theme.of(context).textTheme.titleLarge,
        ).animate().fadeIn(),
        const SizedBox(height: 16),
        _buildStageTimer(
          context,
          'Pre-Teaching',
          controller.preTeachingTime,
          controller.isPreTeachingRunning,
          controller.togglePreTeaching,
          Colors.blue,
        ),
        _buildStageTimer(
          context,
          'Presentation',
          controller.presentationTime,
          controller.isPresentationRunning,
          controller.togglePresentation,
          Colors.green,
        ),
        _buildStageTimer(
          context,
          'Practice',
          controller.practiceTime,
          controller.isPracticeRunning,
          controller.togglePractice,
          Colors.orange,
        ),
        _buildStageTimer(
          context,
          'Production',
          controller.productionTime,
          controller.isProductionRunning,
          controller.toggleProduction,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStageTimer(
    BuildContext context,
    String title,
    RxString timeDisplay,
    RxBool isRunning,
    VoidCallback onToggle,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.timer, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Obx(() => Text(
                    timeDisplay.value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
                ],
              ),
            ),
            Obx(() => IconButton(
              icon: Icon(
                isRunning.value ? Icons.pause : Icons.play_arrow,
                color: color,
              ),
              onPressed: onToggle,
            )),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }
}
