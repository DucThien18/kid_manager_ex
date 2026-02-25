class FirestorePaths {
  static const users = 'users';
  static const children = 'location';

  static String child(String id) => '$children/$id';
}
