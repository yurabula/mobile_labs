abstract class LocalStorageInterface {
  Future<void> init();
  Future<bool> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<bool> saveMap(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getMap(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}
