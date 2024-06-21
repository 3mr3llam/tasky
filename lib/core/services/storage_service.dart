// services/storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  Future<String?> readString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<bool> readBool(String key) async {
    var value = await _secureStorage.read(key: key);
    return bool.parse(value ?? "false");
  }

  Future<void> delete(String key) async {
    await _secureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _secureStorage.deleteAll();
  }

  Future<bool> hasKey(String key) async {
    var hasKey = await _secureStorage.containsKey(key: key);
    return hasKey;
  }
}
