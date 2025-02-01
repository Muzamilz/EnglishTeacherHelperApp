import 'package:get/get.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/intro/views/intro_view.dart';
import '../modules/lesson_planner/bindings/lesson_planner_binding.dart';
import '../modules/lesson_planner/views/lesson_planner_view.dart';
import '../modules/attendance/bindings/attendance_binding.dart';
import '../modules/attendance/views/attendance_view.dart';
import '../modules/grades/bindings/grades_binding.dart';
import '../modules/grades/views/grades_view.dart';
import '../modules/timer/bindings/timer_binding.dart';
import '../modules/timer/views/timer_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.INTRO;

  static final routes = [
    GetPage(
      name: Routes.INTRO,
      page: () => const IntroView(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.LESSON_PLANNER,
      page: () => const LessonPlannerView(),
      binding: LessonPlannerBinding(),
    ),
    GetPage(
      name: Routes.ATTENDANCE,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: Routes.GRADES,
      page: () => const GradesView(),
      binding: GradesBinding(),
    ),
    GetPage(
      name: Routes.TIMER,
      page: () => const TimerView(),
      binding: TimerBinding(),
    ),
  ];
}
