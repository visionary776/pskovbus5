import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pskov_bus_5/response.dart';
import 'package:pskov_bus_5/result.dart';
import 'package:pskov_bus_5/stopsList.dart';
import 'colors.dart';
import 'favorite.dart';
import 'repository.dart';
import 'package:pskov_bus_5/shared_preferences_util.dart';

StopList stopsListClass=StopList();
Repository repository=Repository();
//Favorite favorite = Favorite([], [], []);

String stopUser="";
int stopId=0;
Result result=Result([""], [""]);
Future<Result?> responseFuture=Future.value(result);
Response response=Response("", responseFuture);

var stopsList=stopsListClass.getNames();// изначальные списки
var routeList=stopsListClass.getRoutes();

List<String> favList=[]; // списки фаворитов
var favListRoutes=[];
var favListId=[];
var favouriteCounter=0;//счетчик записанных фаворитов
var favPointer=1;
var stopListMix=[];// списки смешивающие фаворитов и изначальный список
var routeListMix=[];
String favStop="";
String favRoutes="";
int favId=0;
Favorite fav=Favorite([], [], []);

class StopNameListView extends StatefulWidget{


StopNameListView(  {Key? key,  }):super(key: key);


@override
_StopNameListViewState createState()=>_StopNameListViewState();

}

class _StopNameListViewState extends State<StopNameListView>{

late Future <int> fav1,fav2,fav3,fav4,fav5,favCounter;

//Favorite fav=Favorite([], [], []);
int _selectedIndex = -1;
 _StopNameListViewState();


  @override
  void initState(){
    super.initState();



      setState(() {
        fav= Provider.of<Favorite>(context, listen: false);
      //  print("******** favList from Provider::::: ${fav.favList}");

        loadFavorite();
      //  print("******** favList from loadFavorite() in  init::::: ${favList}");
        if (favList.isEmpty){
          favListId=fav.favListId;
          favList=fav.favList;
          favListRoutes=fav.favListRoutes;
          favouriteCounter=favList.length;

       //   print("****Скопировали из Provider!!");
        }






        //  print("******** favList in SetState::::: $favList");
        stopListMix.clear();
        routeListMix.clear();



        if (favList.isNotEmpty){
       // print("********Добавили favList::::: $favList");
          stopListMix.addAll(favList);
          routeListMix.addAll(favListRoutes);


        }

        stopListMix.addAll(stopsList);
        routeListMix.addAll(routeList);


       // print ("stopListMix:  ${stopListMix.toString()} ");

      });







  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Список остановок"),),

        body: Container(
          color: colorBkgr,

          child: ListView.builder(
                padding:const EdgeInsets.all(9),
                itemCount: stopListMix.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(

                    title:Text(stopListMix[index] ,
                      style: TextStyle(fontSize: 17),) ,
                    subtitle: Text("   "+routeListMix[index],
                      style: TextStyle(fontSize: 13,fontStyle: FontStyle.italic, color: Colors.black54),) ,
                    selectedTileColor: Colors.limeAccent,
                    selected: index == _selectedIndex,







                    onTap: (){
                      setState(() {
                        // устанавливаем индекс выделенного элемента
                        _selectedIndex = index;
                      });


                        if(favList.isEmpty){
                      showSnackBar(' Длинное нажатие добавляет в начало списка!');
                        }

                      if(favouriteCounter>0 && favList.isNotEmpty){
                         if(index>=favouriteCounter) {
                           stopId=stopsListClass.getId(index-favouriteCounter);
                               }else if(favListId.isNotEmpty){
                                     stopId=favListId[index];
                                        }
                           }else{
                        stopId=stopsListClass.getId(index);

                      }
                                print ("Запрос расписания stopId:$stopId");
                     // result.timeTable=timeTableList.timeTable;

                      response=fetchDatas(stopId,index);
                      Navigator.pop(context, response);
                    },

                    onLongPress: (()async {
                      setState(() {
                        _selectedIndex = index;
                     addFavorite(index);
                     response=fetchDatas(stopId,index);


                       showSnackBar('$stopUser Добавлена в мои остановки!');
                        Navigator.pop(context, response);
                      });
                    }
                    ),
                  );
                },
              ),
        )
    );
  }


  Response fetchDatas (int stopId,index){

    responseFuture=repository.fetchData(stopId);
    response.stopName=stopListMix[index];
    response.futureResult=responseFuture;
    return response;
  }
 void addFavorite(int index){




   if(favouriteCounter>0 && favList.isNotEmpty){

     if(index>=favouriteCounter) {

       stopId=stopsListClass.getId(index-favouriteCounter);
     }else{
       final snackBar = SnackBar(content: Text('Эта остановка уже в моем списке!'));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
       stopId=favListId[index];
     }

   }else{
     stopId=stopsListClass.getId(index);
   }


    stopUser=stopListMix[index];

   /*if(favouriteCounter<5){
     favouriteCounter++;

   }*/

    SharedPreferencesUtil.saveData("fav$favPointer", stopId);
  //  SharedPreferencesUtil.saveData("favCounter", favouriteCounter);
    print ("******ЗАПИСАНО:     $stopUser,  fCounter: $favouriteCounter, fPointer: $favPointer , StopID:   $stopId, index: $index", );




    favPointer++;
    if (favPointer==6){
      favPointer=1;
    }
   loadFavorite();

  }

void loadFavorite(){


  SharedPreferencesUtil.getFavorite().then((Favorite favorite){
    favListId=favorite.favListId;

    favList=favorite.favList;
   // print("******** favList in getFavorite()::::: $favList");
    favListRoutes=favorite.favListRoutes;
    favouriteCounter=favorite.favList.length;
  });
}

void showSnackBar(String massage){
  final snackBar = SnackBar(
    content: Text(massage,
      textAlign: TextAlign.center,

      style: TextStyle(color:Colors.black54),
    ),
    width: 330.0,
    padding: const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 3.0,
      // Inner padding for SnackBar content.
    ),

    backgroundColor: Colors.lime,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);

}

}