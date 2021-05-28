import 'package:pskov_bus_5/result.dart';

class Response{

  String? stopName;
  Future <Result?>? futureResult;

  Response(String s, Future<Result?> f){
    stopName=s;
    futureResult=f;
  }

}