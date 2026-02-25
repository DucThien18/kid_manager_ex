class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email.trim());
  }
}
