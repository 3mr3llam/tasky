import 'package:get/get.dart';
import 'package:tasky/core/middlewares/auth_middleware.dart';
import 'package:tasky/features/auth/presentation/pages/login_page.dart';
import 'package:tasky/features/auth/presentation/pages/register_page.dart';
import 'package:tasky/features/onboarding/logic/onboarding_middleware.dart';
import 'package:tasky/features/onboarding/presentation/pages/onbaording_page.dart';
import 'package:tasky/features/profile/presentation/pages/profile_page.dart';
import 'package:tasky/features/qr_code/presentation/pages/qr_code_page.dart';
import 'package:tasky/features/task/presentation/pages/add_task_page.dart';
import 'package:tasky/features/task/presentation/pages/edit_task_page.dart';
import 'package:tasky/features/task/presentation/pages/task_details_page.dart';
import 'package:tasky/features/tasks/presentation/pages/tasks_page.dart';

class AppRouter {
  // static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/';
  static const register = '/register';
  static const tasks = '/tasks';
  static const taskDetails = '/taskDetails';
  static const editTask = '/editTask';
  static const addTask = '/addTask';
  static const profile = '/profile';
  static const qrCode = '/qrCode';

  static final List<GetPage> routes = [
    GetPage(
        name: login,
        page: () => const LoginPage(),
        middlewares: [AuthMiddleware()]),
    GetPage(name: register, page: () => const RegisterPage()),
    GetPage(
        name: onboarding,
        page: () => const OnbaordingPage(),
        middlewares: [OnboardingMiddleware()]),
    GetPage(name: profile, page: () => const ProfilePage()),
    GetPage(name: taskDetails, page: () => const TaskDetailsPage()),
    GetPage(name: editTask, page: () => const EditTaskPage()),
    GetPage(name: addTask, page: () => const AddTaskPage()),
    GetPage(name: tasks, page: () => const TasksPage()),
    GetPage(name: qrCode, page: () => const QrCodePage()),
  ];
}
