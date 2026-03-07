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
  late String simtitle;
  late Future<Box> future;
  @override
  void initState() {
    super.initState();
    simtitle=widget.title;
    future = Hive.openBox('data');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading:FloatingActionButton(tooltip:"go back to edit your dataset",onPressed:(){Navigator.of(context).pop();},child:Icon(Icons.arrow_back,size:20)),
        title:Text(simtitle,style:TextStyle(fontSize:25)),
        actions:[
          FloatingActionButton(backgroundColor:Colors.white,child: Icon(Icons.play_arrow,color:Colors.green),onPressed:(){}),
          FloatingActionButton(backgroundColor:Colors.white,child: Icon(Icons.pause,color:Colors.green),onPressed:(){}),
          Text("SimSpeed",style:TextStyle(fontSize:20)),
          FloatingActionButton(backgroundColor:Colors.white,child: Icon(Icons.add,color:Colors.green),onPressed:(){}),
          FloatingActionButton(backgroundColor:Colors.white,child: Icon(Icons.remove,color:Colors.green),onPressed:(){}),
          MenuAnchor(
            builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(icon: Icon(Icons.download),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});} ,
            menuChildren: [TextButton(child: Text("Download data"),onPressed:(){}),TextButton(child: Text("Download frames"),onPressed:(){}),TextButton(child: Text("Download video animation"),onPressed:(){})],
          ),

        ]
      ),
      
    ); 
  }
}