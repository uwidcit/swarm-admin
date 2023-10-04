import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._constructor();

  /// Factory constructor that returns a single instantiated instance of this class
  factory SharedPreferencesManager() => _instance;

  SharedPreferencesManager._constructor();

  SharedPreferences? preferences;

  Future<SharedPreferences> getSharedPref() async {
    preferences ??= await SharedPreferences.getInstance();
    return preferences!;
  }

  Future<void> saveAccessToken(String accessToken) async {
    final prefs = await getSharedPref();
    await prefs.setString('token', accessToken);
  }

  Future<String> getAccessToken() async {
    final prefs = await getSharedPref();
    return prefs.getString("token") ?? "";
  }

  Future<void> clearAll() async {
    final prefs = await getSharedPref();
    prefs.clear();
  }

  Future<void> removeAccessToken() async {
    final prefs = await getSharedPref();
    await setUserDetailJson("");
    prefs.remove("token");
  }

  Future<void> setUserDetailJson(String userDetailJson) async {
    final prefs = await getSharedPref();
    await prefs.setString("user_json", userDetailJson);
  }

  Future<String> getUserDetailJson() async {
    final prefs = await getSharedPref();
    return prefs.getString("user_json") ?? "";
  }
}
