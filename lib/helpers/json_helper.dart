import 'dart:convert';

class JsonHelper {
  /// Encode bất kỳ object nào có toJson()
  static String encode(Map<String, dynamic> json) {
    return jsonEncode(json);
  }

  /// Decode raw string -> Map<String, dynamic>
  static Map<String, dynamic> decode(String raw) {
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
