
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{
  String loginKey = "logInKey";
  String imageKey = "imageKey";

  Future<void> saveimage({required String imagePath})async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(imageKey, imagePath);
  }

  Future<String?> getimage()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(imageKey);
  }


  setLoginState({bool? state})async{
     final SharedPreferences prefs =await SharedPreferences.getInstance();
     prefs.setBool(loginKey, state!);
   }

   getLoginState()async{
     final prefs = await SharedPreferences.getInstance();
     return prefs.getBool(loginKey);
   }


}