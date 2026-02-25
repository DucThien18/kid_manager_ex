
import 'package:kid_manager/models/app_user.dart';

extension AppUserDisplay on AppUser {
  String get displayLabel {
    if (displayName?.isNotEmpty == true) return displayName!;
    if (email?.isNotEmpty == true) return email!;
    return 'Unknown';
  }

  String get displayEmail {
    if (email?.isNotEmpty == true) return email!;
    return 'Unknown';
  }

  String get initials {
    final name = displayLabel.trim();
    return name.isEmpty ? '?' : name[0].toUpperCase();
  }
}
