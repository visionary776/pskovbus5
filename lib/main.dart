import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pskov_bus_5/response.dart';
import 'package:pskov_bus_5/result.dart';
import 'package:pskov_bus_5/stopNameListView.dart';

import 'colors.dart';



var stopNameList = StopNameListView();
// List <String> dataList=[];
Result result=Result([""], [""]);
Future<Result> responseFuture=Future.value(result);
Response? response=Response("", responseFuture);



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Автобусы Пскова табло',
      theme: ThemeData(

        primarySwatch: Colors.lightGreen,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Автобусы Пскова',

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String? title;

  MyHomePage({Key? key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? stopUser = " ";


  _MyHomePageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(

        color: colorBkgr,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StopNameListView()));


                  setState(() {
                    stopUser = response!.stopName??"Не выбрана";

                  //  print("получена остановка:  $stopUser");

                    // dataList=resultTable(result);
                 //  print("response:  ${response.futureResult.toString()}");
                    //  stopName=stopNameList.stopUser;
                  });
                },
                child: Text(
                  "Выбрать остановку",
                  style: TextStyle(fontSize: 18),
                )),
            Padding(
              padding: EdgeInsets.all(3),
              child: Text(
                '$stopUser',
                style: TextStyle(fontSize: 17),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(3),
                child: Container(
                  color: colorBkgr,
                  constraints: BoxConstraints(maxHeight: 390),
                  //constraints: BoxConstraints(maxWidth: 190),
                  child: TimeTableListView(),
                )),
          ],
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class TimeTableListView extends StatefulWidget {


  TimeTableListView({ Key? key}) : super(key: key);

  @override
  _TimeTableListViewState createState() => _TimeTableListViewState();
}

class _TimeTableListViewState extends State<TimeTableListView> {


  @override
  Widget build(BuildContext context) {
    return
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            FutureBuilder<Result?>(
              future: response!.futureResult,
              builder: (context, snapshot){
                if (snapshot.hasData){
                 // print("--------------snapshot.routes:  ${snapshot.data!.routes.toString()}");
                  return Expanded(
                    child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.routes.length,


                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 18,
                        child: RichText(
                          text: TextSpan(
                            text:snapshot.data!.routes[index],
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black),
                            children:<TextSpan>[
                              TextSpan(
                                  text: snapshot.data!.timeTable[index],
                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,color: Colors.black)
                              )
                            ],
                          ),

                        ),
                      );
                    },
                  ),


                  );

                }else if(snapshot.hasError){
                  return Expanded(
                     // padding: EdgeInsets.all(3),


                      child: Text("${snapshot.error}"));
                }
                return Text("");
              }




            ),

    ],
    );



  }
}

/*
List<String>resultTable(Result result){
  List <String> resultTable;
  for(int i=0; i<result.routes.length; i++) {
    resultTable.add(result.routes[i]+":")

  }}
*/




