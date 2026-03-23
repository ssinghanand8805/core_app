import 'package:get/get.dart';
import '../core/enums/user_role.dart';
import '../core/services/storage_service.dart';
import '../data/datasources/local/app_database.dart';
import '../data/datasources/local/post_local_datasource.dart';
import '../data/datasources/local/user_local-datasource.dart';
import '../data/datasources/remote/admin_remote_datasource.dart';
import '../data/datasources/remote/auth_remote_datasource.dart';
import '../data/datasources/remote/post_remote_datasource.dart';
import '../data/datasources/remote/trainer_remote_datasource.dart';
import '../data/datasources/remote/user_remote_datasource.dart';
import '../data/repositories/admin_repository_impl.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/post_repository_impl.dart';
import '../data/repositories/trainer_repository_impl.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/usecases/assign_workout.dart';
import '../domain/usecases/create_post.dart';
import '../domain/usecases/delete_post.dart';
import '../domain/usecases/forgot_password.dart';
import '../domain/usecases/get_all_payments.dart';
import '../domain/usecases/get_all_trainers.dart';
import '../domain/usecases/get_all_users.dart';
import '../domain/usecases/get_payments.dart';
import '../domain/usecases/get_posts.dart';
import '../domain/usecases/get_subscriptions.dart';
import '../domain/usecases/get_users.dart';
import '../domain/usecases/get_workouts.dart';
import '../domain/usecases/login.dart';
import '../domain/usecases/logout.dart';
import '../domain/usecases/reset_password.dart';
import '../domain/usecases/update_post.dart';
import '../domain/usecases/verify_otp.dart';
import '../presentation/controllers/admin_controller.dart';
import '../presentation/controllers/auth_controller.dart';
import '../presentation/controllers/post_controller.dart';
import '../presentation/controllers/trainer_controller.dart';
import '../presentation/controllers/user_controller.dart';
import '../presentation/pages/admin/all_payments_page.dart';
import '../presentation/pages/admin/manage_trainers_page.dart';
import '../presentation/pages/admin/manage_users_page.dart';
import '../presentation/pages/auth/forgot_password_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/dashboard/dashboard_page.dart';
import '../presentation/pages/new_post_page.dart';
import '../presentation/pages/posts_page.dart';
import '../presentation/pages/settings-page.dart';
import '../presentation/pages/trainer/assign_workout_page.dart';
import '../presentation/pages/trainer/trainer_users_page.dart';
import '../presentation/pages/user/my_workouts_page.dart';
import '../presentation/pages/user/payment_history_page.dart';
import '../presentation/pages/user/subscription_page.dart';
import '../presentation/pages/users_page.dart';
import 'app_routes.dart';

final _db = AppDatabase();

AuthRepositoryImpl _authRepo() =>
    AuthRepositoryImpl(remote: AuthRemoteDataSourceImpl());
TrainerRepositoryImpl _trainerRepo() =>
    TrainerRepositoryImpl(remote: TrainerRemoteDataSourceImpl());
AdminRepositoryImpl _adminRepo() =>
    AdminRepositoryImpl(remote: AdminRemoteDataSourceImpl());

BindingsBuilder _authBinding() => BindingsBuilder(() {
      Get.lazyPut<AuthRepositoryImpl>(() => _authRepo());
      Get.lazyPut(() => AuthController(
            loginUseCase: Login(Get.find()),
            logoutUseCase: Logout(Get.find()),
            forgotPasswordUseCase: ForgotPassword(Get.find()),
            verifyOtpUseCase: VerifyOtp(Get.find()),
            resetPasswordUseCase: ResetPassword(Get.find()),
          ));
    });

BindingsBuilder _dashboardBinding() => BindingsBuilder(() {
      Get.lazyPut<PostRepositoryImpl>(() => PostRepositoryImpl(
            remote: PostRemoteDataSourceImpl(),
            local: PostLocalDataSourceImpl(_db),
          ));
      Get.lazyPut<UserRepositoryImpl>(() => UserRepositoryImpl(
            remote: UserRemoteDataSourceImpl(),
            local: UserLocalDataSourceImpl(_db),
          ));

      Get.lazyPut<TrainerRepositoryImpl>(() => _trainerRepo());
      Get.lazyPut<AdminRepositoryImpl>(() => _adminRepo());
      // Get.lazyPut(() => _trainerRepo());
      // Get.lazyPut(() => _adminRepo());

      Get.lazyPut(() => PostController(
            getPosts: GetPosts(Get.find()),
            createPost: CreatePost(Get.find()),
            updatePost: UpdatePost(Get.find()),
            deletePost: DeletePost(Get.find()),
          ));
      Get.lazyPut(() => UserController(getUsers: GetUsers(Get.find())));
      Get.lazyPut(() => TrainerController(
            getWorkouts: GetWorkouts(Get.find<TrainerRepositoryImpl>()),
            assignWorkout: AssignWorkout(Get.find<TrainerRepositoryImpl>()),
            getSubscriptions:
                GetSubscriptions(Get.find<TrainerRepositoryImpl>()),
          ));
      Get.lazyPut(() => AdminController(
            getAllUsersUseCase: GetAllUsers(Get.find()),
            getAllTrainersUseCase: GetAllTrainers(Get.find()),
            getAllPaymentsUseCase: GetAllPayments(Get.find()),
            getAllSubscriptionsUseCase: GetSubscriptions(Get.find()),
          ));
    });

List<GetPage> get appPages => [
      GetPage(
          name: AppRoutes.login,
          page: () => const LoginPage(),
          binding: _authBinding()),
      GetPage(
          name: AppRoutes.forgotPassword,
          page: () => const ForgotPasswordPage()),
      GetPage(
          name: AppRoutes.adminDashboard,
          page: () => const DashboardPage(),
          binding: _dashboardBinding()),
      GetPage(
          name: AppRoutes.trainerDashboard,
          page: () => const DashboardPage(),
          binding: _dashboardBinding()),
      GetPage(
          name: AppRoutes.userDashboard,
          page: () => const DashboardPage(),
          binding: _dashboardBinding()),
      GetPage(
          name: AppRoutes.assignWorkout, page: () => const AssignWorkoutPage()),
      GetPage(
          name: AppRoutes.trainerUsers, page: () => const TrainerUsersPage()),
      GetPage(name: AppRoutes.myWorkouts, page: () => const MyWorkoutsPage()),
      GetPage(
          name: AppRoutes.subscription, page: () => const SubscriptionPage()),
      GetPage(
          name: AppRoutes.paymentHistory,
          page: () => const PaymentHistoryPage()),
      GetPage(name: AppRoutes.manageUsers, page: () => const ManageUsersPage()),
      GetPage(
          name: AppRoutes.manageTrainers,
          page: () => const ManageTrainersPage()),
      GetPage(name: AppRoutes.allPayments, page: () => const AllPaymentsPage()),
      GetPage(name: AppRoutes.posts, page: () => const PostsPage()),
      GetPage(name: AppRoutes.newPost, page: () => const NewPostPage()),
      GetPage(name: AppRoutes.users, page: () => const UsersPage()),
      GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
    ];
