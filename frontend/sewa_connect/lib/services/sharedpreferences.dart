
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper{
  String loginKey = "logInKey";

   setLoginState({bool? state})async{
     final SharedPreferences prefs =await SharedPreferences.getInstance();
     prefs.setBool(loginKey, state!);
   }

   getLoginState()async{
     final prefs = await SharedPreferences.getInstance();
     return prefs.getBool(loginKey);
   }


}