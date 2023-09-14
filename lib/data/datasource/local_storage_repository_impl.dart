import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepositoryInterface {
  @override
  Future<bool?> isDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDarkTheme');
  }

  @override
  Future<void> updateCurrentTheme(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
  }

  @override
  Future<String?> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_language');
  }

  @override
  Future<void> updateAppLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('current_language', languageCode);
  }

  @override
  Future<bool> readRemeberUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberUsername') ?? false;
  }

  @override
  Future updateRemeberUsername(bool? rememberUsername) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberUsername', rememberUsername ?? false);
  }

  @override
  Future<String> readUsername() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'username') ?? '';
  }

  @override
  Future updateCredentials(String username, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);
  }

  @override
  Future storeToken(String token, DateTime expiresAt) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'token', value: token);
    await storage.write(key: 'expires_at', value: expiresAt.toIso8601String());
  }

  @override
  Future<Map<String, String?>> readToken() async {
    const storage = FlutterSecureStorage();
    return {
      'token': await storage.read(key: 'token'),
      'expires_at': await storage.read(key: 'expires_at'),
    };
  }

  @override
  Future<UserModel?> readUser() async {
    const storage = FlutterSecureStorage();
    final userJson = await storage.read(key: 'user');
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  @override
  Future storeUser(String userJson) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'user', value: userJson);
  }

  @override
  Future deleteAuthData() async {
    const storage = FlutterSecureStorage();
    await Future.wait([
      storage.delete(key: 'user'),
      storage.delete(key: 'token'),
      storage.delete(key: 'expires_at'),
    ]);
  }
}
