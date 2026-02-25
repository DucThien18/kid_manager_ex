class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String gender;
  final String dob;
  final String address;
  final bool allowTracking;

  // 🔥 thêm mới (nullable)
  final String? avatarUrl;
  final String? coverUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.address,
    required this.allowTracking,
    this.avatarUrl,
    this.coverUrl,
  });

  /// 🔹 Convert sang Firestore
  Map<String, dynamic> toMap() {
    final data = {
      "displayName": name, // đồng bộ với createChildAccount
      "phone": phone,
      "gender": gender,
      "dob": dob,
      "address": address,
      "allowTracking": allowTracking,
      "avatarUrl": avatarUrl,
      "coverUrl": coverUrl,
    };

    // 🔥 tự động bỏ null field
    data.removeWhere((key, value) => value == null);

    return data;
  }

  /// 🔹 Tạo object từ Firestore
  factory UserProfile.fromMap(String id, Map<String, dynamic> data) {
    return UserProfile(
      id: id,
      name: data["displayName"] ?? "",
      phone: data["phone"] ?? "",
      gender: data["gender"] ?? "",
      dob: data["dob"] ?? "",
      address: data["address"] ?? "",
      allowTracking: data["allowTracking"] ?? false,
      avatarUrl: data["avatarUrl"], // nullable
      coverUrl: data["coverUrl"],   // nullable
    );
  }
}