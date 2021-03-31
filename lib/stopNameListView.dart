

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pskov_bus_5/response.dart';
import 'package:pskov_bus_5/result.dart';

import 'package:pskov_bus_5/stopsList.dart';
import 'colors.dart';
import 'repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pskov_bus_5/shared_preferences_util.dart';

StopList stopsListClass=StopList();
Repository repository=Repository();

String stopUser="Не выбрана остановка";
int stopId=0;
Result result=Result([""], [""]);
Future<Result?> responseFuture=Future.value(result);
Response response=Response("", responseFuture);

var stopsList=stopsListClass.getNames();


var routeList=stopsListClass.getRoutes();

var favList=[""];
var favListRoutes=[""];
var favouriteCounter=0;
var favPointer=1;
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


      setState(() {

        SharedPreferencesUtil.getData("favCounter").then((int counter){
          favouriteCounter=counter;
        });


     if (favouriteCounter > 0) {
       for (var i = 1; i<=favouriteCounter; i++) {
         SharedPreferencesUtil.getData("fav$i").then ((int data){

           String favStop=stopsListClass.getName(data);
           String favRoutes=stopsListClass.getRoutesForOne(data);
           favList.add(favStop);
           print ("favStop[$i]:   $favStop ");

           favListRoutes.add(favRoutes);

         });
       }
     }

      });

  }

//var stopsListBase=stopsListClass.getNames();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Список остановок"),),

        body: Container(
          color: colorBkgr,


          child:ListView.builder(

            padding:const EdgeInsets.all(9),

            itemCount: stopsList.length,
            itemBuilder: (BuildContext context, int index){
              return ListTile(
                title:Text(stopsList[index] ,
                  style: TextStyle(fontSize: 17),) ,
                subtitle: Text("   "+routeList[index],
                  style: TextStyle(fontSize: 13,fontStyle: FontStyle.italic, color: Colors.black54),) ,

                onTap: (){

                 stopUser=stopsList[index];
                 stopId=stopsListClass.getId(index);
                 responseFuture=repository.fetchData(stopId) ;
                  response.stopName=stopUser;
                  response.futureResult=responseFuture; // result.timeTable=timeTableList.timeTable;
                 Navigator.pop(context, response);
                },

               onLongPress: (()async {
                 setState(() {

                   if(favouriteCounter<5){
                     favouriteCounter++;
                   }
                   stopUser=stopsList[index];
                   stopId=stopsListClass.getId(index);
                   response.stopName=stopUser;
                   SharedPreferencesUtil.saveData("fav$favPointer", stopId);
                   SharedPreferencesUtil.saveData("favCounter", favouriteCounter);
                   print ("******Записана остановка:     $stopUser,  favoriteCounter: $favouriteCounter, favPointer: $favPointer");



                   favPointer++;
                   if (favPointer==5){
                     favPointer=1;
                   }

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

}