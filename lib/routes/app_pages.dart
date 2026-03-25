import 'package:get/get.dart';
import '../data/datasources/local/app_database.dart';
import '../presentation/bindings/admin_binding.dart';
import '../presentation/bindings/admin_dashboard_binding.dart';
import '../presentation/bindings/auth_binding.dart';
import '../presentation/bindings/post_binding.dart';
import '../presentation/bindings/trainer_binding.dart';
import '../presentation/bindings/trainer_dashboard_binding.dart';
import '../presentation/bindings/user_binding.dart';
import '../presentation/bindings/user_dashboard_binding.dart';
import '../presentation/pages/admin/all_payments_page.dart';
import '../presentation/pages/admin/manage_trainers_page.dart';
import '../presentation/pages/admin/manage_users_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/new_post_page.dart';
import '../presentation/pages/posts_page.dart';
import '../presentation/pages/settings-page.dart';
import '../presentation/pages/splash_screen.dart';
import '../presentation/pages/trainer/assign_workout_page.dart';
import '../presentation/pages/trainer/trainer_users_page.dart';
import '../presentation/pages/user/my_workouts_page.dart';
import '../presentation/pages/user/payment_history_page.dart';
import '../presentation/pages/user/subscription_page.dart';
import '../presentation/pages/user/user_detail_page.dart';
import '../presentation/pages/users_page.dart';
import 'app_routes.dart';

final _db = AppDatabase();

List<GetPage> get appPages => [
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginPage(),
    binding: AuthBinding(),
  ),
  GetPage(
    name: AppRoutes.splash,
    page: () => const SplashPage(),
  ),
  GetPage(
    name: AppRoutes.forgotPassword,
    page: () => const ForgotPasswordPage(),
  ),
  GetPage(
    name: AppRoutes.adminDashboard,
    page: () => const DashboardPage(),
    binding: AdminDashboardBinding(),
  ),
  GetPage(
    name: AppRoutes.trainerDashboard,
    page: () => const DashboardPage(),
    binding: TrainerDashboardBinding(),
  ),
  GetPage(
    name: AppRoutes.userDashboard,
    page: () => const DashboardPage(),
    binding: UserDashboardBinding(),
  ),
  GetPage(
    name: AppRoutes.manageUsers,
    page: () => const ManageUsersPage(),
    binding: AdminBinding(),
  ),
  GetPage(
    name: AppRoutes.userDetail,
    page: () => const UserDetailPage(),
  ),
  GetPage(
    name: AppRoutes.manageTrainers,
    page: () => const ManageTrainersPage(),
    binding: AdminBinding(),
  ),
  GetPage(
    name: AppRoutes.allPayments,
    page: () => const AllPaymentsPage(),
    binding: AdminBinding(),
  ),
  GetPage(
    name: AppRoutes.trainerUsers,
    page: () => const TrainerUsersPage(),
    binding: TrainerBinding(),
  ),
  GetPage(
    name: AppRoutes.assignWorkout,
    page: () => const AssignWorkoutPage(),
    binding: TrainerBinding(),
  ),
  GetPage(
    name: AppRoutes.myWorkouts,
    page: () => const MyWorkoutsPage(),
    binding: TrainerBinding(),
  ),
  GetPage(
    name: AppRoutes.subscription,
    page: () => const SubscriptionPage(),
    binding: TrainerBinding(),
  ),
  GetPage(
    name: AppRoutes.paymentHistory,
    page: () => const PaymentHistoryPage(),
  ),
  GetPage(
    name: AppRoutes.posts,
    page: () => const PostsPage(),
    binding: PostBinding(_db),
  ),
  GetPage(
    name: AppRoutes.newPost,
    page: () => const NewPostPage(),
    binding: PostBinding(_db),
  ),
  GetPage(
    name: AppRoutes.users,
    page: () => const UsersPage(),
    binding: UserBinding(_db),
  ),
  GetPage(
    name: AppRoutes.settings,
    page: () => const SettingsPage(),
  ),
];
