import 'dart:core';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pskov_bus_5/stopsList.dart';
import 'favorite.dart';


class SharedPreferencesUtil {


  static  saveData(String key, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

 prefs.setInt(key,id);
   // print("сохранили $key: $id ");
  }


  static Future <Favorite> getFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List <int>favListId = [];
    Favorite favorite = Favorite([], [], []);
    StopList stopsListClass = StopList();

    for (int i = 1; i < 6; i++) {
      var data = prefs.getInt("fav$i") ?? 0;


      if (data != 0) {
        favListId.add(data);
      }
    }
    var favouriteCounter = favListId.length;
    for (var i = 0; i < favouriteCounter; i++) {
      var value = favListId[i];
      var favStop = stopsListClass.getName(value);
      var favRoutes = stopsListClass.getRoutesForOne(value);
      favorite.favList.insert(i, favStop);
      favorite.favListRoutes.insert(i, favRoutes);
    }


    favorite.favList = favorite.favList.take(favouriteCounter).toList();
    favorite.favListRoutes =
        favorite.favListRoutes.take(favouriteCounter).toList();
    favorite.favListId = favListId;

    return favorite;
  }

}