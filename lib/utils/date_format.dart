/// Parse "Xh Ym" -> total minutes
int parseUsageTimeToMinutes(String? text) {
  if (text == null || text.isEmpty) return 0;

  final hourMatch = RegExp(r'(\d+)h').firstMatch(text);
  final minMatch = RegExp(r'(\d+)m').firstMatch(text);

  final hours = hourMatch != null ? int.parse(hourMatch.group(1)!) : 0;
  final minutes = minMatch != null ? int.parse(minMatch.group(1)!) : 0;

  return hours * 60 + minutes;
}

/// Format minutes -> "Xh Ym"
String formatUsageMinutes(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return "${h}h ${m}m";
}


// convert text to datetime
DateTime? parseDateFromText(String text) {
  if (text.trim().isEmpty) return null;

  try {
    final parts = text.split('/');
    if (parts.length != 3) return null;

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    // 1️⃣ Chặn năm vô lý
    final now = DateTime.now();
    if (year < 1900 || year > now.year) return null;

    final date = DateTime(year, month, day);

    // 2️⃣ Validate ngược lại (31/02, 30/02...)
    if (date.day != day || date.month != month || date.year != year) {
      return null;
    }

    // 3️⃣ Không cho ngày trong tương lai
    if (date.isAfter(now)) return null;

    return date;
  } catch (_) {
    return null;
  }
}

bool isChildAgeValid(DateTime dob) {
  final now = DateTime.now();
  final age = now.year - dob.year -
      ((now.month < dob.month ||
              (now.month == dob.month && now.day < dob.day))
          ? 1
          : 0);

  return age <= 18;
}