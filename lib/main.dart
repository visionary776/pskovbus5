import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pskov_bus_5/response.dart';
import 'package:pskov_bus_5/result.dart';
import 'package:pskov_bus_5/stopNameListView.dart';
import 'package:pskov_bus_5/shared_preferences_util.dart';
import 'colors.dart';
import 'favorite.dart';





Result result=Result([""], [""]);
Future<Result> responseFuture=Future.value(result);
Response? response=Response("", responseFuture);
Favorite favorite = Favorite([], [], []);
var stopNameList = StopNameListView();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favorite>(
      create: (context) => Favorite([], [], []),
      child: MaterialApp(
        title: 'Автобусы Пскова табло',
        theme: ThemeData(

          primarySwatch: Colors.lightGreen,

          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(
          title: 'Автобусы Пскова',

        ),
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
void initState(){
  super.initState();
  setState(() {
    SharedPreferencesUtil.getFavorite().then((Favorite fav){
      favorite=fav;
     // print("******** setState in main::::: ${favorite.favList}");
    });

  });
}



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
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black),
                            children:<TextSpan>[
                              TextSpan(
                                  text: snapshot.data!.timeTable[index],
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Colors.black)
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






