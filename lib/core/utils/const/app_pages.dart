import 'package:baseball_ai/core/utils/const/app_route.dart';
import 'package:baseball_ai/views/features/auth/binding/auth_binding.dart';
import 'package:baseball_ai/views/features/auth/screens/auth_screen.dart';
import 'package:baseball_ai/views/features/auth/screens/login_screen.dart';
import 'package:baseball_ai/views/features/auth/screens/forgot_password_screen.dart';
import 'package:baseball_ai/views/features/auth/screens/otp_verification_screen.dart';
import 'package:baseball_ai/views/features/auth/screens/reset_password_screen.dart';
import 'package:baseball_ai/views/features/boarding/bindings/boarding_binding.dart';
import 'package:baseball_ai/views/features/boarding/screens/boarding_screen.dart';
import 'package:baseball_ai/views/features/main_parent/bottom_nav/binding/main_parent_binding.dart';
import 'package:baseball_ai/views/features/main_parent/bottom_nav/main_parent_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/arm_care/arm_care_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/bindings/home_sub_binding.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/daily_short/screens/daily_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/throwing_journal/home_throwing_journal_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/hiting_journal/hiting_journal_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/lifting/lifting_screen.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/performance/performance_screen.dart';
import 'package:baseball_ai/views/features/main_parent/nutrution/bindings/nutrution_binding.dart';
import 'package:baseball_ai/views/features/main_parent/nutrution/screens/nutrition_screen.dart';
import 'package:baseball_ai/views/features/main_parent/profile/screens/profile_screen.dart';
import 'package:baseball_ai/views/features/main_parent/progress/binding/progress_binding.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/visualization/binding/visualization_binding.dart';
import 'package:baseball_ai/views/features/main_parent/home/sub_screens/visualization/screens/visualization_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static List<GetPage> app_pages = [
    GetPage(
      name: AppRoute.boarding,
      page: () => BoardingScreen(),
      binding: BoardingBinding(),
    ),
    GetPage(
      name: AppRoute.main,
      page: () => MainParentScreen(),
      binding: MainParentBinding(),
    ),

    GetPage(
      name: AppRoute.progress,
      page: () => ProfileScreen(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: AppRoute.visualation,
      page: () => VisualizationScreen(),
      binding: VisualizationBinding(),
    ),

    GetPage(
      name: AppRoute.dailyShort,
      page: () => DailyShortScreen(),
      binding: HomeSubBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoute.auth,
      page: () => AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoute.signIn,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoute.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoute.otp,
      page: () => const OtpVerificationScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoute.passSet,
      page: () => const ResetPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoute.homethrowing,
      page: () => HomeThrowingJournalScreen(),
      binding: HomeSubBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoute.armCare,
      page: () => ArmCareScreen(),
      binding: HomeSubBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoute.lifting,
      page: () => LiftingScreen(),
      binding: HomeSubBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoute.performance,
      page: () => PerformanceScreen(isWeeklyView: true),
      binding: HomeSubBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoute.nutrution,
      page: () => NutritionScreen(),
      binding: NutrutionBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoute.hitingJournal,
      page: () => HittingJournalScreen(),
      binding: HomeSubBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
