


import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:pskov_bus_5/result.dart';

class Repository {



var url="online.pskovbus.ru";
var path="/wap/online/";

Result ?result=Result([""], ["нет данных..."]);
Future <Result>?  response;
// Result? result;





   Future <Result?> fetchData(int? route) async {

 String routeStr=route.toString();
  // String routeStr="31"; //fake!!

   List<String>routes=[];
   List<String>timeTable=[];
  late String spaceFrmt;

      final response =
     await http.get(Uri.http(url,path, {'st_id':routeStr}));
      if (response.statusCode == 200) {



        final document=html_parser.parse(response.body.toString());
        final elements=document.querySelectorAll("a");


        for (final element in elements){
          final href=element.attributes["href"]!;
          if (href.contains("?mr_id=")& (element.text.length<4)){

            switch(element.text.length){
              case 1:
                spaceFrmt="    ";//3 space
                break;
              case 2:
                spaceFrmt="  "; //2 space
            break;
              case 3:
                spaceFrmt=" ";//1 space
                break;
            }

            routes.add(element.text+":  "+spaceFrmt);
           // print("element in routes: ${element.text}");
          }

          if (href.contains("?srv_id=1&uniqueid=")){
            timeTable.add(element.text);
          }

        }



        //TODO
        result!.routes=routes;
        // result!.routes=routesList;  // fake
        result!.timeTable=timeTable;
        // result!.timeTable=dataList; //fake
      //  print("routes BEFORE CONVERTING: ${result!.routes.toString()}");
      //  print("timetable BEFORE CONVERTING: ${result!.timeTable.toString()}");

        result=convertString(result!);
       // print("routes AFTER CONVERTING: ${result!.routes.toString()}");
      //  print("timetable AFTER CONVERTING: ${result!.timeTable.toString()}"); // print("result: $result");




        return result;


             } else {
                throw Exception('Ошибка получения данных');
      }
   }


 Result convertString(Result result){
     var len=result.routes.length;

     for (int i=0; i<len-1; i++){//  берем поочередно маршрут

       for(int j=i+1; j<len;j++){
        // print( " len=$len. i= $i j=$j ,маршруты:${result.routes[i]}-${result.routes[j]}") ;


         if (result.routes[i]==result.routes[j]){

           if(result.timeTable[i]!=result.timeTable[j]){
             result.timeTable[i]+=(",  "+result.timeTable[j]);
           }

          // print(" Удалили ${ result.routes[j]}");
           result.routes.removeAt(j);

           result.timeTable.removeAt(j);
           j--;
           len--;
         }
       }
        if (i>len-2){
          break;
        }

     }
return result;

 }


 List<String>   dataList = <String>[
    "12:05, 13:22",
    "12:05",
    "12:23",
    "2:00, 13:22",
    "12:05",
    "12:23",



  ];

List <String> routesList =[
  "1:   ","6:   ","2:   ","17:  ","11:  ","16:  "

];

}