import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:three_js_objects/three_js_objects.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js_math/three_js_math.dart' as tmath;
//import 'package:three_js_geometry/three_js_geometry.dart';

class Sim extends StatefulWidget {
  const Sim({super.key, required this.title, required this.simulation,required this.user, required this.timestep,required this.speed, required this.simtime, required this.centroids});
  final String title;
  final List<List<List<double>>> simulation;
  final String user;
  final double timestep;
  final double speed;
  final int simtime;
  final List<three.Vector3> centroids;
  @override
  State<Sim> createState() => Simstate();
}
class Simstate extends State<Sim> {
  late String simtitle;
  late List<List<List<double>>> animdata;
  late Future<Box> future;
  late String user;
  late List<three.Vector3> centroids;
  List<int> roll=[];
  List<int> pitch=[];
  List<int> yaw=[];
  double xf=0, yf=0,zf=0;
  double zoom=1,size=1;
  //Sky sky=Sky();
  
  @override
  void initState() {
    threeJs = three.ThreeJS(
      onSetupComplete: (){setState(() {});},
      setup: setup,
    );
    super.initState();
    simtitle=widget.title;
    animdata=widget.simulation;
    user=widget.user;
    centroids=widget.centroids;
    future = Hive.openBox('data');    
  }

  //late three.AmbientLight ambientlight;
  double ambientlightint=0.5;
  Future<void> setup() async{
    threeJs.camera = three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, 2200);
    threeJs.camera.position.setValues(30, 60, 100);
    threeJs.camera.lookAt(centroids[centroids.length-1]);    
    threeJs.scene = three.Scene();
    final ambientlight=three.AmbientLight(0xffffff,ambientlightint);
    threeJs.scene.add(ambientlight);
    threeJs.scene.add(threeJs.camera);
    three.Mesh object;

    threeJs.camera.lookAt(threeJs.scene.position);
    for (List k in widget.simulation[0]){
      final material = three.MeshBasicMaterial.fromMap({"color":Colors.amber.toARGB32()});
      object = three.Mesh(three.SphereGeometry(k[6]), material);
      
      object.position.setValues(k[0],k[1],k[2]);
      threeJs.scene.add(object);
    }
  }

  late three.ThreeJS threeJs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:future ,
      builder:(context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //print(animdata);
          Map<String, List<dynamic>> simdata =(user != " "? snapshot.data!.get('userdata'): snapshot.data!.get('data_of_computer')).cast<String, List<dynamic>>();
          return Scaffold(
            appBar:AppBar(
              leading:FloatingActionButton(heroTag:null,tooltip:"go back to edit your dataset",onPressed:(){Navigator.of(context).pop();},child:Icon(Icons.arrow_back,size:20)),
              title:Text(simtitle,style:TextStyle(fontSize:25)),
              actions:[
                Icon(Icons.info_outline),
                Text("wasd or arrow keys can be used when paused scene only"),
                FloatingActionButton(heroTag:null,tooltip:"play scene-continue animation",backgroundColor:Colors.white,child: Icon(Icons.play_arrow,color:Colors.green),onPressed:(){}),
                FloatingActionButton(heroTag:null,tooltip:"pause scene",backgroundColor:Colors.white,child: Icon(Icons.pause,color:Colors.green),onPressed:(){}),
                Text("SimSpeed",style:TextStyle(fontSize:20)),
                FloatingActionButton(heroTag:null,backgroundColor:Colors.white,child: Icon(Icons.add,color:Colors.green),onPressed:(){}),
                FloatingActionButton(heroTag:null,backgroundColor:Colors.white,child: Icon(Icons.remove,color:Colors.green),onPressed:(){}),
                MenuAnchor(
                  builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(icon: Icon(Icons.download),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});} ,
                  menuChildren: [TextButton(child: Text("Download data"),onPressed:(){}),TextButton(child: Text("Download frames"),onPressed:(){}),TextButton(child: Text("Download video animation"),onPressed:(){})],
                ),

              ]
            ),
            body: threeJs.build(),
            
            bottomNavigationBar:BottomAppBar(child:Row(children:[
              
              MenuAnchor(
                //style:MenuStyle(backgroundColor:WidgetStateColor.fromMap({WidgetState.any:Colors.})),
                builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(tooltip:"Focus on object",icon:Icon(Icons.filter_center_focus_outlined),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});},
                menuChildren:[for(int k=0; k<simdata[simtitle]!.length;k++) TextButton(onPressed:(){},child:Text(simdata[simtitle]![k].name.toString(),style:TextStyle(fontSize:18)))]
              ),
              IconButton(icon: Icon(Icons.zoom_in),onPressed:(){},tooltip:"Zoom in scene(+)"),
              IconButton(icon: Icon(Icons.zoom_out),onPressed:(){},tooltip:"Zoom out scene(-)"),
              IconButton(icon: Icon(Icons.rotate_right),onPressed:(){},tooltip:"roll right(,)"),
              IconButton(icon: Icon(Icons.rotate_left),onPressed:(){},tooltip:"roll right(.)"),
              IconButton(icon: Icon(Icons.turn_right_sharp),onPressed:(){},tooltip:"yaw right(>)"),
              IconButton(icon: Icon(Icons.turn_left_rounded),onPressed:(){},tooltip:"yaw right(<)"),
              IconButton(icon: Icon(Icons.arrow_downward),onPressed:(){},tooltip:"move along +y axis (a)"),
              IconButton(icon: Icon(Icons.arrow_upward),onPressed:(){},tooltip:"move along +y axis (w)"),
              IconButton(icon: Icon(Icons.arrow_forward),onPressed:(){},tooltip:"move along +x axis (d)"),
              IconButton(icon: Icon(Icons.arrow_back),onPressed:(){},tooltip:"move along -x axis (a)"),
              IconButton(icon: Icon(Icons.adjust),onPressed:(){},tooltip:"move in +z axis (q)"),
              IconButton(icon: Icon(Icons.adjust),onPressed:(){},tooltip:"move in +z axis (q)"),

              Tooltip(message:"This is used to set the scene so that it will accomodate the best position to view all the frames of the animation",child:TextButton(onPressed:(){},child: Text("Fixed scene"),)),
              Tooltip(message:"This is used to set the scene so that it will accomodate the best position to view only the cureent frame",child:TextButton(onPressed:(){},child: Text("Dynamic scene"),)),
              Column(children: [
                SizedBox(height:35,child:Slider(
                  allowedInteraction:SliderInteraction.slideOnly,
                  showValueIndicator:ShowValueIndicator.alwaysVisible,
                  year2023:true,
                  min:0,
                  max:100,
                  divisions:10,
                  value:ambientlightint*100,
                  onChanged:(value){
                    ambientlightint=value/100;
                    //ambientlight.intensity = value/100;
                    setState((){});
                  }
                )),
                Text("Ambient Light(%)",style:TextStyle(fontSize: 15))
              ],)
              //TextButton(onPressed:(){},onHover:(value){ Tooltip(message:"This is used to set the scene so that it will accomodate the best position to view current frame");},child:Text("Dynamic scene"))
            ]))
          ); 
        }
        else{
          return Column(
            children: <Widget>[
              CircularProgressIndicator(strokeWidth: 30, color: Colors.blue),
              Text(
                "Please wait while we fetch your Data",
                style: TextStyle(color: Colors.red),
              ),
            ],
          );
        }
        //simdata=user!=" "?snapshot.data!.get('userdata',defaultValue:simdata):snapshot.data!.get('data_of_computer',defaultValue:simdata);;
        
      },
    );
    
  }
}