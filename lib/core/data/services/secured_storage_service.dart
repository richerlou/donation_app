import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorageService {
  SecuredStorageService._();

  /// Singleton to ensure only one class instance is created
  static final SecuredStorageService _instance = SecuredStorageService._();
  factory SecuredStorageService() => _instance;

  // --- Keys --- //
  String localUserKey = 'localUser';
  // --- Keys --- //

  final FlutterSecureStorage _flutterSecureStorage =
      const FlutterSecureStorage();

  /// Store data in secure storage
  Future<void> writeSecureData(String key, String value) async =>
      await _flutterSecureStorage.write(key: key, value: value);

  /// Read data in secure storage
  Future<String?> readSecureData(String key) async =>
      await _flutterSecureStorage.read(key: key);

  /// Delete data in secure storage
  Future<void> deleteSecureData(String key) async =>
      await _flutterSecureStorage.delete(key: key);
}
