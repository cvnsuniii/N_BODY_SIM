import 'package:flutter/material.dart';
import "simulation.dart";
import 'bodyclass.dart';
import 'package:hive/hive.dart';
import 'dart:math';
// ignore: camel_case_types
class Sim_para extends StatefulWidget {
  const Sim_para({super.key,required this.user, required this.title, required this.coordinates,required this.data});
  final String user;
  final String title;
  final List coordinates;
  final Map<String, List<dynamic>> data;
  
  @override
  State<Sim_para> createState() => Simparastate();
}
class Simparastate extends State<Sim_para> {
  // ignore: non_constant_identifier_names
  late String simtitle;
  late Map<String, List<dynamic>> simdata;
  int valNoBody=0;
  late int n=simdata[simtitle]!.length;
  double offsetY = 1;   // Start off-screen (bottom)
  bool titledit=false;
  bool errortitle=false; 
  late Future<Box> future;
  bool checked=false;
  List<List> distances=[];
  double timestep=200;
  List<double> frame=[10,20,50,75,100,150,200,250,400,500,750,1000,1500,2000];
  bool chkdist(){
    bool checkdist=true;
    for (int k=0; k<simdata[simtitle]!.length;k++){
      List dist=[];
      for (int m=0; m<simdata[simtitle]!.length;m++){
        num disst=pow((pow((simdata[simtitle]![m].lastValue[0]-simdata[simtitle]![k].lastValue[0]),2)+pow((simdata[simtitle]![m].lastValue[1]-simdata[simtitle]![k].lastValue[1]),2)+pow((simdata[simtitle]![m].lastValue[2]-simdata[simtitle]![k].lastValue[2]),2)),0.5);
        //print(disst);
        if (simdata[simtitle]![m].radius+simdata[simtitle]![k].radius>disst&& disst!=0){
          checkdist=false;
        }
        dist.add(disst);
      }
      distances.add(dist);
    }
    return checkdist;
  }
  //bool fuck=false;
  Widget bodyWidget(BuildContext context,int i,snapshot,user,simdata,simtitle){
    bool editbody=false;
    //bool pop=false;
    
    //bool fuck=false;
    
    bool errorpx=false;
    bool errorbody=true;
    bool errorpy=false;
    TextEditingController controllerpx = TextEditingController(text: simdata[simtitle][i].lastValue[0].toString());
    TextEditingController controllerpy = TextEditingController(text: simdata[simtitle][i].lastValue[1].toString());
    TextEditingController controllerpz = TextEditingController(text: simdata[simtitle][i].lastValue[2].toString());
    TextEditingController controllervx = TextEditingController(text: simdata[simtitle][i].lastVelocities[0].toString());
    TextEditingController controllervy = TextEditingController(text: simdata[simtitle][i].lastVelocities[1].toString());
    TextEditingController controllervz = TextEditingController(text: simdata[simtitle][i].lastVelocities[2].toString());
    TextEditingController controllerr = TextEditingController(text: simdata[simtitle][i].radius.toString());
    bool errorpz=false;
    bool errorvz=false;
    bool errorvy=false;
    bool errorvx=false;
    bool errorr=false;
    List<String> colopalNames = [
      "amber",
      "black",
      "blue",
      "Blue Accent",
      "Blue grey",
      "brown",
      "cyan",
      "Cyan accent",
      "Deep Orange",
      "Deep Orange Accent",
      "deep Purple",
      "Deep purple Accent",
      "green",
      "green Accent",
      "Grey (default)",
      "Indigo",
      "Indigo Accent",
      "Light Blue",
      "Light Blue Accent",
      "Light Green",
      "Light Green Accent",
      "Lime",
      "Lime Accent",
      "Orange",
      "Orange Accent",
      "Pink",
      "Pink Accent",
      "Purple",
      "Purple Accent",
      "red",
      "Red Accent",
      "teal",
      "Teal Accent",
      "White",
      "Yellow",
      "Yellow Accent",
    ];
    List<Color> colopal = [
      Colors.amber,
      Colors.black,
      Colors.blue,
      Colors.blueAccent,
      Colors.blueGrey,
      Colors.brown,
      Colors.cyan,
      Colors.cyanAccent,
      Colors.deepOrange,
      Colors.deepOrangeAccent,
      Colors.deepPurple,
      Colors.deepPurpleAccent,
      Colors.green,
      Colors.greenAccent,
      Colors.grey,
      Colors.indigo,
      Colors.indigoAccent,
      Colors.lightBlue,
      Colors.lightBlueAccent,
      Colors.lightGreen,
      Colors.lightGreenAccent,
      Colors.lime,
      Colors.limeAccent,
      Colors.orange,
      Colors.orangeAccent,
      Colors.pink,
      Colors.pinkAccent,
      Colors.purple,
      Colors.purpleAccent,
      Colors.red,
      Colors.redAccent,
      Colors.teal,
      Colors.tealAccent,
      Colors.white,
      Colors.yellow,
      Colors.yellowAccent,
    ];
    //MenuController controller=MenuController(:);
    //if(pop==true){pop=false; Navigator.of(context).pop;};
    String nowcolor(){
      for  (int k=0; k<colopal.length; ){
        if (simdata[simtitle][i].color==colopal[k]){
          return colopalNames[k];
        }
        
      }
      return " ";
    }
    
    return StatefulBuilder(
      builder:(context,
      setStatebody){
        return Column(spacing:20,
          children:[
            Row(spacing:30,children: [
              if (!editbody) Text(simdata[simtitle][i].name,style:TextStyle(fontSize:20)),
              if (editbody) Text("edit the body name here ",style:TextStyle(fontSize:20)),
              if (editbody) SizedBox(width:200,child:TextField(
                
                onChanged:(String text){
                  bool check= true;
                  for (int m=0; m<simdata[simtitle].length;m++){
                    //print(text==simdata[simtitle][m].name);
                    if (text==simdata[simtitle][m].name && m!=i ){
                      check=false;
                      break;
                      //setStatebody((){});
                    }
                  }
                  //print(check);
                  if (text.isNotEmpty&& check){
                    errorbody=false;
                    setStatebody((){});
                  }
                  else{
                    errorbody=true;
                    setStatebody((){});
                  }
                  //print(errorbody);
                },
                onSubmitted:(String text){
                  if (!errorbody){
                    editbody=!editbody;
                    simdata[simtitle][i].name=text;
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    //print(simdata[simtitle][i].name);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (editbody && errorbody) Icon(Icons.info_outlined),
              if (errorbody && editbody) Text("body name cant be duplicate or empty"),
              if (!editbody) IconButton(icon:Icon(Icons.edit),onPressed:(){
                editbody=true;
                setStatebody((){});
                //print(editbody);
              }),
              if (editbody) OutlinedButton(child:Text("cancel",style:TextStyle(fontSize: 20)),onPressed:(){editbody=false;setState((){});}),
              if (!editbody) IconButton(icon:Icon(Icons.delete),onPressed:(){
                if (simdata[simtitle].length==2){
                  
                  showDialog(
                    context:context,
                    builder: (context){
                      return AlertDialog(
                        title:Text("Warning",style:TextStyle(fontSize: 25,fontWeight:FontWeight.bold)),
                        content:Text("number of bodies cannot be less than 2. this action will not be completed",style:TextStyle(fontSize:15)),
                        actions:[OutlinedButton(onPressed:(){ Navigator.of(context).pop();},child:Text("OK",style:TextStyle(fontSize:15)))],
                      );
                    }
                  );
                  
                }
                else{
                  //if(pop==true){pop=false; Navigator.of(context).pop;};
                  showDialog(
                    context:context,
                    builder: (context){
                      return AlertDialog(
                        title:Text("Confirm",style:TextStyle(fontSize: 25,fontWeight:FontWeight.bold)),
                        content:Text("are you sure to delete this object and all its data in the simulation",style:TextStyle(fontSize:15)),
                        actions:[
                          OutlinedButton(onPressed:(){ Navigator.of(context).pop();},child:Text("No",style:TextStyle(fontSize:15,color:Colors.redAccent))),
                          OutlinedButton(child:Text("Yes",style:TextStyle(fontSize:15,color:Colors.green)),onPressed:(){
                            //Navigator.of(context).pop;
                            simdata[simtitle].removeAt(i);
                            user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                            //pop=true;
                            Navigator.of(context).pop();
                            setState((){});
                            setStatebody((){});
                          })
                        ],
                      );
                    }
                  );
                  
                  
                }
                //setState((){});
                
              }),
            ],),
            Row(spacing:20,children: [
              SizedBox(width:200,child:Text("Initial positions",style:TextStyle(fontSize:18))),
              Text("x-",style:TextStyle(fontSize:18)),

              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllerpx,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null){
                    errorpx=false;
                  }
                  else{
                    errorpx=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorpx){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].lastValue[0]=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorpx) Icon(Icons.error,color:Colors.red),
              if (errorpx) Text("only real numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ],),
            Row(spacing:20,children:[
              SizedBox(width:200),
              Text("y-",style:TextStyle(fontSize:18)),
              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllerpy,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null){
                    errorpy=false;
                  }
                  else{
                    errorpy=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorpy){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].lastValue[1]=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorpy) Icon(Icons.error,color:Colors.red),
              if (errorpy) Text("only real numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ]),
            Row(spacing:20,children:[
              SizedBox(width:200),
              Text("z-",style:TextStyle(fontSize:18)),
              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllerpz,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null){
                    errorpz=false;
                  }
                  else{
                    errorpz=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorpz){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].lastValue[2]=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorpz) Icon(Icons.error,color:Colors.red),
              if (errorpz) Text("only real numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ]),
            Row(spacing:20,children:[
              SizedBox(width: 200,child:Text("Color of Body",style:TextStyle(fontSize:18))),
              //Text(nowcolor(),style:TextStyle(fontSize:18)),
              //Text(nowcolor(),style:TextStyle(fontSize:18)),
              MenuAnchor(
                builder:(BuildContext context, MenuController controller, Widget? child) {return TextButton(onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}},child: Text("",style:TextStyle(fontSize: 18)),);},// fucking check the fucking error here 
                
                menuChildren:[
                  for (int m=0; m<colopal.length; m++) ListTile(onTap:(){simdata[simtitle][i].color=colopal[m].toARGB32();user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);setStatebody((){});setState((){});},leading:Container(width:18,height:18 ,decoration:BoxDecoration(color:colopal[m],border:BoxBorder.all(width:2,color:Colors.black))),title:Text(colopalNames[m],style:TextStyle(fontSize:18)))
                ]
              )
            ]),
            Row(spacing:20,children: [
              SizedBox(width:200,child:Text("Radius of body",style:TextStyle(fontSize:18))),
              Text("R-",style:TextStyle(fontSize:18)),
              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllerr,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null && n>=0){
                    errorr=false;
                  }
                  else{
                    errorr=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorr){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].radius=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorr) Icon(Icons.error,color:Colors.red),
              if (errorr) Text("only positive(or 0) numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ],),
            
            
            Row(spacing:20,children:[
              SizedBox(width:200,child:Text("Initial velocity",style:TextStyle(fontSize:18))),
              //SizedBox(width:200),
              Text("Vx-",style:TextStyle(fontSize:18)),
              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllervx,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null){
                    errorvx=false;
                  }
                  else{
                    errorvx=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorvx){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].lastVelocities[0]=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorvx) Icon(Icons.error,color:Colors.red),
              if (errorvx) Text("only real numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ],),
            Row(spacing:20,children:[
              SizedBox(width:200),
              Text("Vy-",style:TextStyle(fontSize:18)),
              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllervy,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null){
                    errorvy=false;
                  }
                  else{
                    errorvy=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorvy){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].lastVelocities[1]=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorvy) Icon(Icons.error,color:Colors.red),
              if (errorvy) Text("only real numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ]),
            Row(spacing:20,children:[
              SizedBox(width:200),
              Text("Vz-",style:TextStyle(fontSize:18)),
              SizedBox(width:200,child:TextField(
                //readOnly:enablepx,
                
                decoration:InputDecoration(),
                controller:controllervz,
                onChanged:(String text){
                  int? n=int.tryParse(text);
                  if (n!=null){
                    errorvz=false;
                  }
                  else{
                    errorvz=true;
                  }
                  setStatebody((){});
                },
                
                onSubmitted:(String text){
                  if (!errorvz){
                    //print(simdata[simtitle][i].lastValue);
                    simdata[simtitle][i].lastVelocities[2]=int.parse(text);
                    user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                    setStatebody((){});
                    setState((){});
                  }
                }
              )),
              if (errorvz) Icon(Icons.error,color:Colors.red),
              if (errorvz) Text("only real numbers can be used and not empty",style:TextStyle(fontSize:15)),
            ]),
            Row(children: [
              Text("please note that the initial accelerations are 0, which means no external forces.",style:TextStyle(fontSize:15))
            ],),
            SizedBox(height:40)
          ]
        );
      }
    );
    
  }
  double sp1=1;
  int run=1;
  void fuck(int a){
    if (a==1&& run==30){}
    else if (a==1){
      if (run%3==1){
        sp1*=2.5;
      }
      else{
        sp1*=2;
      }
      run++;
      setState((){});
    }
    else if (run==1&& a==-1) {}

    else{
      if (run%3==2){
        sp1/=2.5;
      }
      else{
        sp1/=2;
      }
      run--;
      setState((){});
    }
  }
  
  Widget simspeed(context){
    
    
  
    return Row(spacing:30,children: [
      Text("Simulation speed",style:TextStyle(fontSize:18)),
      IconButton(icon:Icon(Icons.add),onPressed:(){fuck(1);}),
      Text(sp1.toString(),style:TextStyle(fontSize:18)),
      IconButton(icon:Icon(Icons.remove),onPressed:(){fuck(-1);})
    ],);

    
  }
  int simtimes=10;
  
  Widget simtime(BuildContext context){
    TextEditingController controllersimtime=TextEditingController(text: simtimes.toString());
    bool errorsimtime=false;
    return StatefulBuilder(builder: (context, setStatesimtime) {
      return Row(
        spacing:10,children:[
          
          SizedBox(
            width:200,
            child:  TextField(
              maxLength:3,
              controller:controllersimtime,
              onChanged:(String text){
                int? n=int.tryParse(text);
                if (n!=null){
                  if (n<=0|| (n<timestep/1000)){
                    
                    errorsimtime=true;
                  }
                  else{
                    errorsimtime=false;
                    
                  }
                }
                else{
                  errorsimtime=true;
                }
                setStatesimtime((){});
              },
              onSubmitted:(String text){
                if (!errorsimtime){
                  simtimes=int.parse(text);
                  setState((){});
                }
              
              }
            )
          ),
          if(errorsimtime) Icon(Icons.error,color:Colors.red),
          if(errorsimtime) Text("time cannot be this datatype/ negative/empty/less than timestep"),
        ]
      );
      
      
    });
  }



  @override
  void initState() {
    super.initState();
    simtitle=widget.title;
    simdata=widget.data;
    future = Hive.openBox('data');
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        offsetY = 0;   // Slide to normal position
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:future,
      builder:(context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          //simdata=widget.user!=" "?snapshot.data!.get('userdata',defaultValue:simdata):snapshot.data!.get('data_of_computer',defaultValue:simdata);
          Map<String, List<dynamic>> simdata =(widget.user != " "? snapshot.data!.get('userdata', defaultValue: widget.data): snapshot.data!.get('data_of_computer', defaultValue: widget.data)).cast<String, List<dynamic>>();
          //print(snapshot.data!.get('userdata'));
          print(simdata);
          return Scaffold(
            appBar:AppBar(
              leading:FloatingActionButton(tooltip:"go back.some changes may be saved.",heroTag: null,onPressed:( (){Navigator.of(context).pop();}),child:Icon(Icons.arrow_back,size:20)),
              title:Text("Simulation Parameters",style:TextStyle(color:Colors.black,fontSize:30)),
              actions:[if(checked) FloatingActionButton(heroTag: null,backgroundColor:Colors.blueAccent,onPressed:()async{await Navigator.of(context).push(MaterialPageRoute(builder: (context){return Sim(title:simtitle,data:simdata,user:widget.user,timestep:timestep,speed:sp1,simtime:simtimes);}));setState((){});},child:Text("Simulate",style:TextStyle(color: Colors.white)))]
            ),
            body:Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(bottom:50,right:120,left:120,top:80),
                decoration: BoxDecoration(

                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/background_main.png"),
                  ),
                ),
                child:AnimatedSlide(
                  duration: Duration(seconds: 1),
                  offset: Offset(0, offsetY),
                  curve:Curves.easeInOutSine,
                  child:SingleChildScrollView(
                    child:Container(
                      padding:EdgeInsets.all(50),
                      width:double.infinity,
                      
                      decoration:BoxDecoration(color:Colors.white.withValues(alpha:0.9),borderRadius:BorderRadius.circular(5),boxShadow:[BoxShadow(color:Colors.black,spreadRadius:5)]),
                      child:Column(children: [
                        Center(child:Row(crossAxisAlignment : CrossAxisAlignment.center,spacing:20,children: [
                          if (!titledit)Text(simtitle,style:TextStyle(fontSize:25,color:Colors.black)),
                          if(!titledit) IconButton(icon:Icon(Icons.edit),onPressed:(){titledit=!titledit;setState((){});}),
                          if (titledit) Text("Enter your title here ",style:TextStyle(fontSize:25,color:Colors.black)),
                          if(titledit) SizedBox(width:200,child:TextField(
                            
                              onChanged: (String text){
                                if (widget.data.keys.toList().contains(text)&& text !=simtitle){
                                  errortitle=true;
                                  setState((){});
                                }
                                
                                else{
                                  errortitle=false;
                                  setState((){});
                                }
                              },                      
                              onSubmitted:(String text){
                                
                                if (!errortitle){
                                  //print(text);print(widget.title);print(widget.data['ss']);print(widget.data[widget.title]);
                                  simdata[text]=simdata[simtitle]!;
                                  simdata.remove(simtitle);
                                  simtitle=text;
                                  titledit=!titledit;
                                  widget.user!=" " ?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                                  //print(simdata);
                                  setState((){});

                                }
                              }
                            ),
                          ),
                          if (titledit &&errortitle) Icon(Icons.error,color:Colors.red),
                          if (titledit &&errortitle) Text("you have already used this") ,
                          if (titledit &&errortitle) Text("title cannot be empty") ,
                          if (titledit) OutlinedButton(child:Text("cancel",style:TextStyle(fontSize:15)),onPressed:(){titledit=!titledit;setState((){});}),
                          if (titledit) Icon(Icons.info_outlined,size:20),
                          if(titledit) Text("press enter to change",style:TextStyle(fontSize: 15))
                        ],)),
                        
                        Row(spacing:20,children: [
                          Text("Number of Bodies",style:TextStyle(color:Colors.black,fontSize:20)),
                          SizedBox(
                            width:200,
                            child:TextField(
                              style:TextStyle(color:Colors.black,fontSize:20),
                              maxLength:3,
                              onChanged:(String nowstr){
                                int? n=int.tryParse(nowstr);
                                if (n!=null){
                                  if (n<2){
                                    valNoBody=2;
                                    n=2;
                                  }
                                  else{
                                    valNoBody=0;
                                  }
                                }
                                else{
                                  valNoBody=1;
                                  n=2;
                                }
                                setState((){});
                              },
                              onSubmitted:(String text){
                                //print(valNoBody);
                                if (valNoBody==0 ){
                                  List<BodyDetails> simu=[];
                                  for (int i=0; i<int.parse(text);i++){
                                    int m=i+1;
                                    simu.add(BodyDetails('Body $m',[0,0,0],[0,0,0],[0,0,0],0,Colors.grey.toARGB32()));
                                  }
                                  //print(simu);
                                  simdata[simtitle]=simu;
                                  widget.user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                                }
                                else {
                                  //return showDialog();
                                  simdata[simtitle]=[BodyDetails('Body 1',[0,0,0],[0,0,0],[0,0,0],0,Colors.grey.toARGB32()),BodyDetails('Body 2',[0,0,0],[0,0,0],[0,0,0],0,Colors.grey.toARGB32())];
                                  widget.user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                                }
                                setState((){});
                              },
                            ),
                          ),
                          SizedBox(width: 100,),
                          if (valNoBody==1||valNoBody==2) Icon(Icons.dangerous,color:Colors.red),
                          if (valNoBody==1) Text("invalid number type.please enter a integer",style:TextStyle(color:Colors.black,fontSize:14)),
                          if(valNoBody==2) Text("Input cant be negative and less than 2",style:TextStyle(color:Colors.black,fontSize:14)),
                        ],),
                        Row(spacing:20,children:[Icon(Icons.info_outlined,size:15),Text("Press Enter to validate the number of bodies.note that using this feature discards all previous bodies and creates a new list of bodies with this number")]),
                        SizedBox(height:30),
                        Row(spacing:30,children: [Icon(Icons.info_outlined,size:20),Text("please press enter to make changes in every text field.")],),
                        for(int i=0; i<(simdata[simtitle]!.length); i++) bodyWidget(context,i,snapshot,widget.user,simdata,simtitle),
                        Row(spacing:50,children:[
                          Tooltip(message:"advised to choose according to your computer capabilities",child:Text("Frame time/ timestep(ms)",style:TextStyle(fontSize:18))),
                          MenuAnchor(
                            builder:(BuildContext context,MenuController controller,Widget? child) {
                              return TextButton(onPressed: (){if(controller.isOpen){controller.close();} else{controller.open();}},child:Text("$timestep ms",style:TextStyle(fontSize:18)));
                            },
                            menuChildren: [for(int k=0; k<frame.length; k++) ListTile(selectedColor:Colors.lime,focusColor:Colors.grey,onTap:(){timestep=frame[k];setState((){});},title:Text(frame[k].toString(),style:TextStyle(fontSize:18)))],
                          ),
                        ]),                      
                        SizedBox(height:10),
                        simspeed( context),
                        SizedBox(height: 10,),
                        Row(spacing:50,children:[
                          Text("Total time so simulation in s-",style:TextStyle(fontSize:18)),
                          simtime(context),
                        ]),
                        SizedBox(height:30),
                        Row(spacing:30,children:[
                          SizedBox(width:200,height:40,child:FloatingActionButton(heroTag:null,backgroundColor:Colors.green,child:Text("check & Save",style:TextStyle(color: Colors.white)),onPressed:(){
                            bool checkdist= chkdist();
                            
                            if (checkdist&& !titledit){
                              checked=true;
                              setState((){});
                            }
                            else{
                              
                              checked=false;
                              setState((){});
                              showDialog(context:context,builder:(BuildContext context) {
                                return AlertDialog(
                                  title:Text("Warning",style:TextStyle(fontSize:25)),
                                  content:Text("please check your values again. 2 bodies cannot be sticking together or inside one another before simulation starts",style:TextStyle(fontSize:18)),
                                  actions:[OutlinedButton(onPressed: (){Navigator.of(context).pop();},child:Text("Ok",style:TextStyle(fontSize:18)))]
                                );
                              },);
                            }
                          })),
                          if(checked) SizedBox(height:40,width:150,child:FloatingActionButton(heroTag:null,backgroundColor:Colors.blueAccent,onPressed:(){
                            if(chkdist()) {()async{ await Navigator.of(context).push(MaterialPageRoute(builder: (context){return Sim(title:simtitle,data:simdata,user:widget.user,timestep:timestep,speed:sp1,simtime:simtimes);}));setState((){});}; }
                            else {showDialog(context:context,builder:(BuildContext context) {
                              return AlertDialog(
                                title:Text("Warning",style:TextStyle(fontSize:25)),
                                content:Text("please check your values again. 2 bodies cannot be sticking together or inside one another before simulation starts",style:TextStyle(fontSize:18)),
                                actions:[OutlinedButton(onPressed: (){Navigator.of(context).pop();},child:Text("Ok",style:TextStyle(fontSize:18)))]
                              );
                            },);}
                          },child:Text("Simulate",style:TextStyle(color: Colors.white)))),
                          FloatingActionButton(heroTag:null,tooltip:"add new body",child:Icon(Icons.add,size:30),onPressed:(){n+=1;simdata[simtitle]!.add(BodyDetails("Body $n",[0,0,0],[0,0,0],[0,0,0],0,Colors.grey.toARGB32()));widget.user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);setState((){});}),
                          MenuAnchor(
                            menuChildren:[TextButton(child: Text("Download data"),onPressed:(){}),TextButton(child: Text("Download frames"),onPressed:(){}),TextButton(child: Text("Download video animation"),onPressed:(){})],
                            
                            builder:(BuildContext context, MenuController controller,Widget? child){return IconButton(icon: Icon(Icons.download),onPressed:(){if (controller.isOpen){controller.close();} else{controller.open();}});}
                          )
                        ])
                      ],)
                    ),
                  ),
                )
              )
            )
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
      },
    );
     
        
    
  }
}