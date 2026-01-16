enum UserType { user, adimn, manager }

UserType getUserTypeByKey(String key) {
  if (key == 'manager') return UserType.manager;
  if (key == 'admin') return UserType.adimn;
  return UserType.user;
}
