// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../features/auth/models/user_model.dart';
//
// class Prefs {
//   static late SharedPreferences _instance;
//
//   static Future<void> init() async {
//     _instance = await SharedPreferences.getInstance();
//   }
//
//   static Future<void> setBool(String key, bool value) async {
//     await _instance.setBool(key, value);
//   }
//
//   static bool getBool(String key) {
//     return _instance.getBool(key) ?? false;
//   }
//
//   static Future<void> setString(String key, String value) async {
//     await _instance.setString(key, value);
//   }
//
//   static String getString(String key) {
//     return _instance.getString(key) ?? '';
//   }
//
//   static Future<void> remove(String key) async {
//     await _instance.remove(key);
//   }
//
//   static Future<void> saveUser(UserModel userModel) async {
//     String userJson = jsonEncode(userModel.toMap());
//     await setString('user_data', userJson);
//   }
//
//   static UserModel getUser() {
//     String jsonString = getString('user_data');
//     return UserModel.fromJson(jsonDecode(jsonString));
//   }
// }