import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerController extends GetxController {
  // Main timer variables
  final mainTimeDisplay = '00:00'.obs;
  final isMainRunning = false.obs;
  Timer? mainTimer;
  int mainSeconds = 0;
  int totalMainSeconds = 0;

  // Stage timers
  final preTeachingTime = '00:00'.obs;
  final presentationTime = '00:00'.obs;
  final practiceTime = '00:00'.obs;
  final productionTime = '00:00'.obs;

  final isPreTeachingRunning = false.obs;
  final isPresentationRunning = false.obs;
  final isPracticeRunning = false.obs;
  final isProductionRunning = false.obs;

  Timer? preTeachingTimer;
  Timer? presentationTimer;
  Timer? practiceTimer;
  Timer? productionTimer;

  int preTeachingSeconds = 0;
  int presentationSeconds = 0;
  int practiceSeconds = 0;
  int productionSeconds = 0;

  @override
  void onClose() {
    mainTimer?.cancel();
    preTeachingTimer?.cancel();
    presentationTimer?.cancel();
    practiceTimer?.cancel();
    productionTimer?.cancel();
    super.onClose();
  }

  void setMainTimer() {
    Get.dialog(
      AlertDialog(
        title: const Text('Set Class Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes',
                hintText: 'Enter class duration in minutes',
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  final minutes = int.parse(value);
                  totalMainSeconds = minutes * 60;
                  mainSeconds = totalMainSeconds;
                  mainTimeDisplay.value = _formatTime(mainSeconds);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _setStageTimers();
              Get.back();
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _setStageTimers() {
    // Pre-teaching: 15% of total time
    preTeachingSeconds = (totalMainSeconds * 0.15).round();
    preTeachingTime.value = _formatTime(preTeachingSeconds);

    // Presentation: 30% of total time
    presentationSeconds = (totalMainSeconds * 0.3).round();
    presentationTime.value = _formatTime(presentationSeconds);

    // Practice: 30% of total time
    practiceSeconds = (totalMainSeconds * 0.3).round();
    practiceTime.value = _formatTime(practiceSeconds);

    // Production: 25% of total time
    productionSeconds = (totalMainSeconds * 0.25).round();
    productionTime.value = _formatTime(productionSeconds);
  }

  void toggleMainTimer() {
    if (isMainRunning.value) {
      mainTimer?.cancel();
    } else {
      mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (mainSeconds > 0) {
          mainSeconds--;
          mainTimeDisplay.value = _formatTime(mainSeconds);
        } else {
          timer.cancel();
          isMainRunning.value = false;
          _playAlarm();
        }
      });
    }
    isMainRunning.toggle();
  }

  void resetMainTimer() {
    mainTimer?.cancel();
    isMainRunning.value = false;
    mainSeconds = totalMainSeconds;
    mainTimeDisplay.value = _formatTime(mainSeconds);
  }

  void togglePreTeaching() => _toggleStageTimer(
    isPreTeachingRunning,
    preTeachingTimer,
    preTeachingSeconds,
    preTeachingTime,
    (timer) => preTeachingTimer = timer,
  );

  void togglePresentation() => _toggleStageTimer(
    isPresentationRunning,
    presentationTimer,
    presentationSeconds,
    presentationTime,
    (timer) => presentationTimer = timer,
  );

  void togglePractice() => _toggleStageTimer(
    isPracticeRunning,
    practiceTimer,
    practiceSeconds,
    practiceTime,
    (timer) => practiceTimer = timer,
  );

  void toggleProduction() => _toggleStageTimer(
    isProductionRunning,
    productionTimer,
    productionSeconds,
    productionTime,
    (timer) => productionTimer = timer,
  );

  void _toggleStageTimer(
    RxBool isRunning,
    Timer? timer,
    int seconds,
    RxString timeDisplay,
    Function(Timer?) setTimer,
  ) {
    if (isRunning.value) {
      timer?.cancel();
      setTimer(null);
    } else {
      var remainingSeconds = seconds;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds > 0) {
          remainingSeconds--;
          timeDisplay.value = _formatTime(remainingSeconds);
        } else {
          timer.cancel();
          isRunning.value = false;
          _playAlarm();
        }
      });
      setTimer(timer);
    }
    isRunning.toggle();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _playAlarm() {
    // Play sound notification when timer ends
    Get.snackbar(
      'Time\'s Up!',
      'The timer has finished.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }

  Color getTimeColor() {
    if (mainSeconds == 0) return Colors.red;
    final percentage = mainSeconds / totalMainSeconds;
    if (percentage > 0.5) return Colors.green;
    if (percentage > 0.25) return Colors.orange;
    return Colors.red;
  }
}
