class ApiEndpoints {
  static const String posts          = '/posts';
  static const String users          = '/users';
  static const String comments       = '/comments';
  static const String login          = '/auth/login';
  static const String logout         = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp      = '/auth/verify-otp';
  static const String resetPassword  = '/auth/reset-password';
  static const String workouts       = '/workouts';
  static const String subscriptions  = '/subscriptions';
  static const String payments       = '/payments';
  static const String trainers       = '/trainers';
  static const String adminUsers     = '/admin/users';
  static const String adminPayments  = '/admin/payments';

  static String postById(int id)    => '/posts/$id';
  static String userById(int id)    => '/users/$id';
  static String workoutById(int id) => '/workouts/$id';
}