import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserIdService {
  static const _storage = FlutterSecureStorage();
  static const _upIdKey = 'UPId';

  static Future<int?> getUserId() async {
    final String? upIdString = await _storage.read(key: _upIdKey);
    if (upIdString == null) return null;
    return int.tryParse(upIdString);
  }

  static Future<void> setUserId(int upId) async {
    await _storage.write(key: _upIdKey, value: upId.toString());
  }

  static Future<void> clearUserId() async {
    await _storage.delete(key: _upIdKey);
  }
}