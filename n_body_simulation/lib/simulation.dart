import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:three_js_objects/three_js_objects.dart';
import 'package:three_js/three_js.dart' as three;
//import 'package:three_js_math/three_js_math.dart' as tmath;
import 'dart:math';
import 'dart:async';
//import 'package:three_js_geometry/three_js_geometry.dart';

class Sim extends StatefulWidget {
  const Sim({super.key, required this.title, required this.simulation,required this.user, required this.timestep,required this.speed, required this.simtime, required this.centroids,required this.simdata,required this.radius});
  final String title;
  final List<List<List<double>>> simulation;
  final String user;
  final double timestep;
  final double speed;
  final int simtime;
  final List<three.Vector3> centroids;
  final Map<String,List<dynamic>> simdata;
  final double radius;
  @override
  State<Sim> createState() => Simstate();
}
class Simstate extends State<Sim> {
  bool intita=false;
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
  List<three.Mesh> objects=[];
  //Sky sky=Sky();
  late Map<String, List<dynamic>> simdata;
  @override
  void initState() {
    
    threeJs = three.ThreeJS(
      onSetupComplete: (){setState(() {intita=true;});animate();},
      setup: setup,
    );

    super.initState();
    simdata= widget.simdata;
    simtitle=widget.title;
    animdata=widget.simulation;
    user=widget.user;
    centroids=widget.centroids;
    
    future = Hive.openBox('data');    
  }
  
  //late three.AmbientLight ambientlight;
  double ambientlightint=0.5;
  Future<void> setup() async{
    double fovRadians = 45 * (pi / 180);
    // Use an offset (e.g., 1.2) to add a small margin around the points
    double distance = (widget.radius / sin(fovRadians / 2)) +widget.radius;
    print(distance);
    threeJs.camera = three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, distance*1.2);
    threeJs.camera.position.setValues(centroids[centroids.length-1].x,centroids[centroids.length-1].y,centroids[centroids.length-1].z+distance);

    //threeJs.camera.position.setValues(centroids[centroids.length-1].x,centroids[centroids.length-1].y,centroids[centroids.length-1].z+dist);
    //threeJs.camera.up=three.Vector3(0, 1, 0); 
    threeJs.camera.lookAt(centroids[centroids.length-1]);    
    
    threeJs.scene = three.Scene();
    final ambientlight=three.AmbientLight(0xffffff,ambientlightint);
    threeJs.scene.add(ambientlight);
    threeJs.scene.add(threeJs.camera);
    //threeJs.camera.lookAt(threeJs.scene.position);

    final material = three.MeshBasicMaterial.fromMap({"color":Colors.grey.toARGB32()});
    three.Mesh object=three.Mesh(three.SphereGeometry(1), material);    
    
    for (int k =0;k< widget.simulation[0].length;k++){
      final material = three.MeshBasicMaterial.fromMap({"color":widget.simdata[simtitle]![k].color});
      object = three.Mesh(three.SphereGeometry(widget.simulation[0][k][6]), material);
      object.position.setValues(widget.simulation[0][k][0],widget.simulation[0][k][1],widget.simulation[0][k][2]);
      //three.AnimationMixer mixer=three.AnimationMixer(object);
      threeJs.scene.add(object);
      objects.add(object);
    }
    
    //threeJs.renderer=three.WebGLRenderer(parameters)
    //threeJs.renderer
  }
  Future<void> animate() async {
    for (int m = 0; m < widget.simulation.length; m++) {

      for (int d = 0; d < objects.length; d++) {
        objects[d].position.setValues(
          widget.simulation[m][d][0],
          widget.simulation[m][d][1],
          widget.simulation[m][d][2],
        );
      }

      threeJs.render(
        threeJs.scene,
        threeJs.camera,
        threeJs.texture,
        widget.timestep / 1000,
      );


      await Future.delayed(
        Duration(milliseconds: (widget.timestep).toInt()),
      );
    }
  }
  
  late three.ThreeJS threeJs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:future ,
      builder:(context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          //Map<String, List<dynamic>> simdata =(user != " "? snapshot.data!.get('userdata'): snapshot.data!.get('data_of_computer')).cast<String, List<dynamic>>();
          /*if(!intita){
            return const Center(child: CircularProgressIndicator()); 
          }*/
          return Scaffold(
            appBar:AppBar(
              leading:FloatingActionButton(heroTag:null,tooltip:"go back to edit your dataset",onPressed:(){Navigator.of(context).pop();},child:Icon(Icons.arrow_back,size:20)),
              title:Text(simtitle,style:TextStyle(fontSize:25)),
              actions:[
                //Icon(Icons.info_outline),
                //Text("wasd or arrow keys can be used when paused scene only"),
                //FloatingActionButton(heroTag:null,tooltip:"play scene-continue animation",backgroundColor:Colors.white,child: Icon(Icons.play_arrow,color:Colors.green),onPressed:(){}),
                //FloatingActionButton(heroTag:null,tooltip:"pause scene",backgroundColor:Colors.white,child: Icon(Icons.pause,color:Colors.green),onPressed:(){}),
                /*Text("SimSpeed",style:TextStyle(fontSize:20)),
                FloatingActionButton(heroTag:null,backgroundColor:Colors.white,child: Icon(Icons.add,color:Colors.green),onPressed:(){}),
                FloatingActionButton(heroTag:null,backgroundColor:Colors.white,child: Icon(Icons.remove,color:Colors.green),onPressed:(){}),
                MenuAnchor(
                  builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(icon: Icon(Icons.download),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});} ,
                  menuChildren: [TextButton(child: Text("Download data"),onPressed:(){}),TextButton(child: Text("Download frames"),onPressed:(){}),TextButton(child: Text("Download video animation"),onPressed:(){})],
                ),*/

              ]
            ),
            body:intita==false?threeJs.build():LayoutBuilder(builder:(context,constraints){double finalHeight = constraints.maxHeight;double finalWidth = constraints.maxWidth;threeJs.camera.aspect = finalWidth / finalHeight;threeJs.camera.updateProjectionMatrix();return SizedBox( // Forces the 3D view to take up all available space
              height:finalHeight,width:finalWidth,child: threeJs.build(),
            );}),
            
            /*bottomNavigationBar:BottomAppBar(child:Row(children:[
              
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
            ]))*/
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