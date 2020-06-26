import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //sharing data to sharedprefernces

  static Future<bool> saveUserNameSharedPreference(String UserName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, UserName);
  }

  static Future<bool> saveUserEmailSharedPreference(String UserEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, UserEmail);
  }

  //getting data from sharedpreferences

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }
}