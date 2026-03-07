import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:three_js/three_js.dart' as three;
class Sim extends StatefulWidget {
  const Sim({super.key, required this.title, required this.data});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final Map data;

  @override
  State<Sim> createState() => Simstate();
}
class Simstate extends State<Sim> {
  late Future<Box> future;
  @override
  void initState() {
    super.initState();
    future = Hive.openBox('data');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading:FloatingActionButton(onPressed:(){Navigator.of(context).pop();},child:Icon(Icons.arrow_back,size:20)),
        //title:Text()
      ),
    ); 
  }
}