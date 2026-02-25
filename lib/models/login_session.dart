class LoginSession {
  final String email;
  final String uid;
  final bool remember;

  const LoginSession({
    required this.email,
    required this.uid,
    required this.remember,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'uid': uid,
        'remember': remember,
      };

  factory LoginSession.fromJson(Map<String, dynamic> json) {
    return LoginSession(
      email: json['email'] as String,
      uid: json['uid'] as String,
      remember: json['remember'] as bool,
    );
  }
}
