import 'package:skeleton_app/data/models/user_model.dart';

abstract class LocalStorageRepositoryInterface {
  Future<bool?> isDarkTheme();
  Future<void> updateCurrentTheme(bool isDarkTheme);

  Future<String?> getCurrentLanguage();
  Future<void> updateAppLanguage(String languageCode);

  Future<bool> readRemeberUsername();
  Future updateRemeberUsername(bool? rememberUsername);
  Future<String> readUsername();
  Future updateCredentials(String username, String password);
  Future storeToken(String token, DateTime expiresAt);
  Future<Map<String, String?>> readToken();

  Future storeUser(String userJson);
  Future<User?> readUser();

  Future deleteAuthData();
}
