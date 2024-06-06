enum UserRole { individual, organization, admin }

extension UserRoleExt on UserRole {
  int code() {
    switch (this) {
      case UserRole.individual:
        return 1;
      case UserRole.organization:
        return 2;
      case UserRole.admin:
        return 3;
      default:
        return 0;
    }
  }

  String text() {
    switch (this) {
      case UserRole.individual:
        return 'Individual';
      case UserRole.organization:
        return 'Organization';
      case UserRole.admin:
        return 'Admin';
      default:
        return 'Unkown';
    }
  }
}

UserRole getUserRole(num userRoleValue) {
  switch (userRoleValue) {
    case 1:
      return UserRole.individual;
    case 2:
      return UserRole.organization;
    case 3:
      return UserRole.admin;
    default:
      return UserRole.organization;
  }
}
