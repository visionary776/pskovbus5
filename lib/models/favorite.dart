import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class Favorite with ChangeNotifier{
  List<String> favList; // списки фаворитов
  List<String> favListRoutes;
  List<int> favListId;


  Favorite(this.favList, this.favListId, this.favListRoutes);

  void setfavList(List<String> value){
    favList=value;
    notifyListeners();

  }  void setfavListRoutes(List<String> value){
    favListRoutes=value;
    notifyListeners();

  }  void setfavListId(List<int> value){
    favListId=value;
    notifyListeners();
  }
}