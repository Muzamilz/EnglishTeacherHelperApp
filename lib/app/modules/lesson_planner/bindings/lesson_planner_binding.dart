import 'package:get/get.dart';
import '../controllers/lesson_planner_controller.dart';

class LessonPlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonPlannerController>(
      () => LessonPlannerController(),
    );
  }
}
