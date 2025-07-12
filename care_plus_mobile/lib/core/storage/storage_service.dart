import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';
import '../constants/app_constants.dart';

/// Secure storage service for sensitive data
class SecureStorageService {
  final FlutterSecureStorage _secureStorage;

  const SecureStorageService({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Store a string value securely
  Future<void> storeString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store secure data: ${e.toString()}',
      );
    }
  }

  /// Retrieve a string value securely
  Future<String?> getString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to read secure data: ${e.toString()}',
      );
    }
  }

  /// Store JSON data securely
  Future<void> storeJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store secure JSON: ${e.toString()}',
      );
    }
  }

  /// Retrieve JSON data securely
  Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(
        message: 'Failed to read secure JSON: ${e.toString()}',
      );
    }
  }

  /// Delete a secure value
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete secure data: ${e.toString()}',
      );
    }
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear secure storage: ${e.toString()}',
      );
    }
  }

  /// Check if a key exists
  Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check secure storage key: ${e.toString()}',
      );
    }
  }

  /// Store authentication tokens
  Future<void> storeAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await storeString(AppConstants.accessTokenKey, accessToken);
    await storeString(AppConstants.refreshTokenKey, refreshToken);
  }

  /// Get authentication tokens
  Future<Map<String, String?>> getAuthTokens() async {
    final accessToken = await getString(AppConstants.accessTokenKey);
    final refreshToken = await getString(AppConstants.refreshTokenKey);
    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  /// Clear authentication tokens
  Future<void> clearAuthTokens() async {
    await delete(AppConstants.accessTokenKey);
    await delete(AppConstants.refreshTokenKey);
  }
}

/// Local storage service for non-sensitive data
class LocalStorageService {
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw CacheException(
        message: 'LocalStorageService not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  /// Store a string value
  Future<bool> setString(String key, String value) async {
    try {
      return await _preferences.setString(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to store string: ${e.toString()}');
    }
  }

  /// Get a string value
  String? getString(String key) {
    try {
      return _preferences.getString(key);
    } catch (e) {
      throw CacheException(message: 'Failed to read string: ${e.toString()}');
    }
  }

  /// Store an integer value
  Future<bool> setInt(String key, int value) async {
    try {
      return await _preferences.setInt(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to store integer: ${e.toString()}');
    }
  }

  /// Get an integer value
  int? getInt(String key) {
    try {
      return _preferences.getInt(key);
    } catch (e) {
      throw CacheException(message: 'Failed to read integer: ${e.toString()}');
    }
  }

  /// Store a boolean value
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _preferences.setBool(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to store boolean: ${e.toString()}');
    }
  }

  /// Get a boolean value
  bool? getBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (e) {
      throw CacheException(message: 'Failed to read boolean: ${e.toString()}');
    }
  }

  /// Store a double value
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _preferences.setDouble(key, value);
    } catch (e) {
      throw CacheException(message: 'Failed to store double: ${e.toString()}');
    }
  }

  /// Get a double value
  double? getDouble(String key) {
    try {
      return _preferences.getDouble(key);
    } catch (e) {
      throw CacheException(message: 'Failed to read double: ${e.toString()}');
    }
  }

  /// Store a list of strings
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      return await _preferences.setStringList(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to store string list: ${e.toString()}',
      );
    }
  }

  /// Get a list of strings
  List<String>? getStringList(String key) {
    try {
      return _preferences.getStringList(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to read string list: ${e.toString()}',
      );
    }
  }

  /// Store JSON data
  Future<bool> setJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      return await _preferences.setString(key, jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to store JSON: ${e.toString()}');
    }
  }

  /// Get JSON data
  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _preferences.getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(message: 'Failed to read JSON: ${e.toString()}');
    }
  }

  /// Remove a key
  Future<bool> remove(String key) async {
    try {
      return await _preferences.remove(key);
    } catch (e) {
      throw CacheException(message: 'Failed to remove key: ${e.toString()}');
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      return await _preferences.clear();
    } catch (e) {
      throw CacheException(message: 'Failed to clear storage: ${e.toString()}');
    }
  }

  /// Check if a key exists
  bool containsKey(String key) {
    try {
      return _preferences.containsKey(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check key existence: ${e.toString()}',
      );
    }
  }

  /// Get all keys
  Set<String> getKeys() {
    try {
      return _preferences.getKeys();
    } catch (e) {
      throw CacheException(message: 'Failed to get keys: ${e.toString()}');
    }
  }
}
