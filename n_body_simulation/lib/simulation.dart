import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:three_js_objects/three_js_objects.dart';
//import 'package:three_js/three_js.dart' as three;
class Sim extends StatefulWidget {
  const Sim({super.key, required this.title, required this.data,required this.user});
  final String title;
  final Map<String,List<dynamic>> data;
  final String user;
  @override
  State<Sim> createState() => Simstate();
}
class Simstate extends State<Sim> {
  late String simtitle;
  late Map<String,List<dynamic>> simdata;
  late Future<Box> future;
  late String user;
  //Sky sky=Sky();
  @override
  void initState() {
    super.initState();
    simtitle=widget.title;
    simdata=widget.data;
    user=widget.user;
    future = Hive.openBox('data');
    
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:future ,
      builder:(context, snapshot) {
        //simdata=user!=" "?snapshot.data!.get('userdata',defaultValue:simdata):snapshot.data!.get('data_of_computer',defaultValue:simdata);;
        Map<String, List<dynamic>> simdata =(user != " "? snapshot.data!.get('userdata', defaultValue: widget.data): snapshot.data!.get('data_of_computer', defaultValue: widget.data)).cast<String, List<dynamic>>();
        return Scaffold(
          appBar:AppBar(
            leading:FloatingActionButton(tooltip:"go back to edit your dataset",onPressed:(){Navigator.of(context).pop();},child:Icon(Icons.arrow_back,size:20)),
            title:Text(simtitle,style:TextStyle(fontSize:25)),
            actions:[
              Icon(Icons.info_outline),
              Text("wasd or arrow keys can be used when paused scene only"),
              FloatingActionButton(tooltip:"play scene-continue animation",backgroundColor:Colors.white,child: Icon(Icons.play_arrow,color:Colors.green),onPressed:(){}),
              FloatingActionButton(tooltip:"pause scene",backgroundColor:Colors.white,child: Icon(Icons.pause,color:Colors.green),onPressed:(){}),
              Text("SimSpeed",style:TextStyle(fontSize:20)),
              FloatingActionButton(backgroundColor:Colors.white,child: Icon(Icons.add,color:Colors.green),onPressed:(){}),
              FloatingActionButton(backgroundColor:Colors.white,child: Icon(Icons.remove,color:Colors.green),onPressed:(){simdata[simtitle]![0].name="fuck";user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);setState((){});}),
              MenuAnchor(
                builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(icon: Icon(Icons.download),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});} ,
                menuChildren: [TextButton(child: Text("Download data"),onPressed:(){}),TextButton(child: Text("Download frames"),onPressed:(){}),TextButton(child: Text("Download video animation"),onPressed:(){})],
              ),

            ]
          ),
          bottomNavigationBar:BottomAppBar(child:Row(children:[
            
            MenuAnchor(
              //style:MenuStyle(backgroundColor:WidgetStateColor.fromMap({WidgetState.any:Colors.})),
              builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(tooltip:"Focus on object",icon:Icon(Icons.filter_center_focus_outlined),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});},
              menuChildren:[for(int k=0; k<simdata[simtitle]!.length;k++) TextButton(onPressed:(){},child:Text(simdata[simtitle]![k].name.toString(),style:TextStyle(fontSize:18)))]
            ),
            IconButton(icon: Icon(Icons.zoom_in),onPressed:(){},tooltip:"Zoom in scene"),
            IconButton(icon: Icon(Icons.zoom_out),onPressed:(){},tooltip:"Zoom out scene"),
            Tooltip(message:"This is used to set the scene so that it will accomodate the best position to view all the frames of the animation",child:TextButton(onPressed:(){},child: Text("Fixed scene"),)),
            Tooltip(message:"This is used to set the scene so that it will accomodate the best position to view only the cureent frame",child:TextButton(onPressed:(){},child: Text("Dynamic scene"),)),
            //TextButton(onPressed:(){},onHover:(value){ Tooltip(message:"This is used to set the scene so that it will accomodate the best position to view current frame");},child:Text("Dynamic scene"))
          ]))
        ); 
      },
    );
    
  }
}