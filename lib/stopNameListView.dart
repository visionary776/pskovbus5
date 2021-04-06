

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pskov_bus_5/response.dart';
import 'package:pskov_bus_5/result.dart';
import 'package:pskov_bus_5/stopsList.dart';
import 'colors.dart';
import 'repository.dart';
import 'package:pskov_bus_5/shared_preferences_util.dart';

StopList stopsListClass=StopList();
Repository repository=Repository();

String stopUser="";
int stopId=0;
Result result=Result([""], [""]);
Future<Result?> responseFuture=Future.value(result);
Response response=Response("", responseFuture);

var stopsList=stopsListClass.getNames();// изначальные списки
var routeList=stopsListClass.getRoutes();

var favList=[]; // списки фаворитов
var favListRoutes=[];
var favListId=[];
var favouriteCounter=0;//счетчик записанных фаворитов
var favPointer=1;
var stopListMix=[];// списки смешивающие фаворитов и изначальный список
var routeListMix=[];
String favStop="";
String favRoutes="";
int favId=0;


class StopNameListView extends StatefulWidget{


StopNameListView({Key? key}):super(key: key);

@override
_StopNameListViewState createState()=>_StopNameListViewState();

}

class _StopNameListViewState extends State<StopNameListView>{

late Future <int> fav1,fav2,fav3,fav4,fav5,favCounter;



  @override
  void initState(){
    super.initState();

    loadFavorite();

      setState(() {

        stopListMix.clear();
        routeListMix.clear();
        if (favList.isNotEmpty){
          stopListMix.addAll(favList);
          routeListMix.addAll(favListRoutes.toList());
        }
/*
  if(favList.isEmpty){
    favList.add("Мои остановки-пусто. Долгое нажатие добавляет..");
    favListRoutes.add(" ");
  }
*/


        print ("favList:  ${favList.toString()} ");

        stopListMix.addAll(stopsList);
        routeListMix.addAll(routeList);

      // loadFavorite();

      });
    // final snackBar = SnackBar(content: Text('$stopUser Длинное нажатие добавляет в начало списка!'));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                    selectedTileColor: Colors.lime,



                    onTap: (){



                      stopId=stopsListClass.getId(index);

                      if(favouriteCounter>0){
                         if(index>=favouriteCounter) {
                           stopId=stopsListClass.getId(index-favouriteCounter);
                         }else if(favListId.isNotEmpty){
                           stopId=favListId[index];



                         }
                      }else{
                        final snackBar = SnackBar(content: Text(' Длинное нажатие добавляет в начало списка!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                                print ("fetchData stopId:$stopId");
                      responseFuture=repository.fetchData(stopId);
                      response.stopName=stopListMix[index];
                      response.futureResult=responseFuture; // result.timeTable=timeTableList.timeTable;
                      Navigator.pop(context, response);
                    },

                    onLongPress: (()async {
                      setState(() {

                     addFavorite(index);

                        final snackBar = SnackBar(content: Text('$stopUser Добавлена в мои остановки!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

 void addFavorite(int index){




   if(favouriteCounter>0){

     if(index>=favouriteCounter) {
      // index -= favouriteCounter;
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
    response.stopName=stopUser;

   if(favouriteCounter<5){
     favouriteCounter++;

   }

    SharedPreferencesUtil.saveData("fav$favPointer", stopId);
    SharedPreferencesUtil.saveData("favCounter", favouriteCounter);
    print ("******Записана остановка:     $stopUser,  favoriteCounter: $favouriteCounter, favPointer: $favPointer , StopID:   $stopId, index: $index", );




    favPointer++;
    if (favPointer==6){
      favPointer=1;
    }
   loadFavorite();

  }

void loadFavorite(){

  SharedPreferencesUtil.getData("favCounter").then((int counter){
    favouriteCounter=counter;
    print ("favoriteCounter SHAREDPREF:   $favouriteCounter");
  });
  if (favouriteCounter > 0) {


    for (var i = 0; i<favouriteCounter; i++) {
      var data= SharedPreferencesUtil.getData("fav${i+1}");

      data.then((int value) {

        if(value>0){
          favStop=stopsListClass.getName(value);
          favRoutes=stopsListClass.getRoutesForOne(value);
          favList.insert(i,favStop);
          favListRoutes.insert(i, favRoutes);
          favListId.insert(i,value);

        }



      });
    }

    favList=favList.take(favouriteCounter).toList();
    favListRoutes=favListRoutes.take(favouriteCounter).toList();
    favListId=favListId.take(favouriteCounter).toList();
  }

 /* stopListMix.clear();
  routeListMix.clear();
  if (favList.isNotEmpty){
    stopListMix.addAll(favList);
    routeListMix.addAll(favListRoutes.toList());
  }
*//*
  if(favList.isEmpty){
    favList.add("Мои остановки-пусто. Долгое нажатие добавляет..");
    favListRoutes.add(" ");
  }
*//*


  print ("favList:  ${favList.toString()} ");

  stopListMix.addAll(stopsList);
  routeListMix.addAll(routeList);*/

}


}