import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesUtil {
  static  saveData(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

 prefs.setInt(key,id);
   // print("сохранили fav1: $id ");
  }

  static Future <int>getData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();



  var res = prefs.getInt(key)??0;
   // print("загрузили fav1: $res ");

    return res;
  }




}