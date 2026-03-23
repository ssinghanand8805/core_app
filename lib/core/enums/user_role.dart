enum UserRole { admin, trainer, user }

extension UserRoleX on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:   return 'admin';
      case UserRole.trainer: return 'trainer';
      case UserRole.user:    return 'user';
    }
  }

  static UserRole fromString(String v) {
    switch (v.toLowerCase()) {
      case 'admin':   return UserRole.admin;
      case 'trainer': return UserRole.trainer;
      default:        return UserRole.user;
    }
  }
}