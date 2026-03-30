import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  String loginKey = "logInKey";
  String imageKey = "imageKey";
  String emailKey = "emailKey";
  String nameKey = "nameKey";

  Future<void> saveName({required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(nameKey, name);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(nameKey);
  }

  Future<void> saveEmail({required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(emailKey, email);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(emailKey);
  }

  Future<void> saveimage({required String imagePath}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(imageKey, imagePath);
  }

  Future<String?> getimage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(imageKey);
  }

  setLoginState({required bool? state}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(loginKey, state!);
  }

  getLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(loginKey);
  }
}
