

// class ChildRepository {
//   final FirebaseFunctions _fn;
//   ChildRepository(this._fn);

//   Future<String> createChild({
//     required String displayName,
//     String? email,
//     String? password,
//     String? phone,
//     String? photoUrl,
//     String locale = 'vi',
//     String timezone = 'Asia/Ho_Chi_Minh',
//   }) async {
//     final callable = _fn.httpsCallable('createChild');
//     final res = await callable.call({
//       'displayName': displayName,
//       'email': email,
//       'password': password,
//       'phone': phone,
//       'photoUrl': photoUrl,
//       'locale': locale,
//       'timezone': timezone,
//     }..removeWhere((k, v) => v == null));
//     return (res.data as Map)['childUid'] as String;
//   }
// }
