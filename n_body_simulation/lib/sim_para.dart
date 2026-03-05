import 'package:flutter/material.dart';
//import "main.dart";
import 'bodyclass.dart';
import 'package:hive/hive.dart';
// ignore: camel_case_types
class Sim_para extends StatefulWidget {
  const Sim_para({super.key,required this.user, required this.title, required this.coordinates,required this.data});
  final String user;
  final String title;
  final List coordinates;
  final Map data;
  
  @override
  State<Sim_para> createState() => Simparastate();
}
class Simparastate extends State<Sim_para> {
  // ignore: non_constant_identifier_names
  late String simtitle;
  late Map simdata;
  int valNoBody=0;
  late int n=simdata[simtitle].length;
  double offsetY = 1;   // Start off-screen (bottom)
  bool titledit=false;
  bool errortitle=false; 
  late Future<Box> future;
  Widget bodyWidget(BuildContext context,int i,snapshot,user,simdata,simtitle){
    bool editbody=false;
    bool pop=false;
    //if(pop==true){pop=false; Navigator.of(context).pop;};
    return StatefulBuilder(
      builder:(context,setStatebody){
        return Column(
          children:[
            Row(spacing:30,children: [
              if (!editbody) Text(simdata[simtitle][i].name,style:TextStyle(fontSize:20)),
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
                  if(pop==true){pop=false; Navigator.of(context).pop;};
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
          ]
        );
      }
    );
    
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
          //print(snapshot.data!.get('userdata'));
          print(simdata);
          return Scaffold(
            appBar:AppBar(
              leading:FloatingActionButton(tooltip:"go back.some changes may be saved.",heroTag: null,onPressed:( (){Navigator.of(context).pop();})),
              title:Text("Simulation Parameters",style:TextStyle(color:Colors.black,fontSize:30)),
              actions:[FloatingActionButton(heroTag: null,backgroundColor:Colors.blueAccent,onPressed:(){},child:Text("Simulate",style:TextStyle(color: Colors.white)))]
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
                                  simdata[text]=simdata[simtitle];
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
                                
                                if (valNoBody==0 ){
                                  List simu=[];
                                  for (int i=0; i<int.parse(text);i++){
                                    int m=i+1;
                                    simu.add(BodyDetails('Body $m',[],[],[0,0,0]));
                                  }
                                  simdata[simtitle]=simu;
                                  widget.user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                                }
                                else {
                                  //return showDialog();
                                  simdata[simtitle]=[BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])];
                                  widget.user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);
                                }
                                setState((){});
                              },
                            ),
                          ),
                          SizedBox(width: 100,),
                          if (valNoBody==1||valNoBody==2) Icon(Icons.dangerous,color:Colors.red),
                          if (valNoBody==1) Text("invalid number type.please enter a integer",style:TextStyle(color:Colors.black,fontSize:14)),
                          if(valNoBody==2) Text("Input cant be negative or less than 2",style:TextStyle(color:Colors.black,fontSize:14)),
                        ],),
                        Row(spacing:20,children:[Icon(Icons.info_outlined,size:15),Text("Press Enter to validate the number of bodies.note that using this feature discards all previous bodies and creates a new list of bodies with this number")]),
                        SizedBox(height:30),
                        for(int i=0; i<(simdata[simtitle].length); i++) bodyWidget(context,i,snapshot,widget.user,simdata,simtitle),
                        Row(spacing:30,children:[
                          SizedBox(width:150,height:40,child:FloatingActionButton(heroTag:null,backgroundColor:Colors.green,onPressed:(){},child:Text("Save",style:TextStyle(color: Colors.white)))),
                          SizedBox(height:40,width:150,child:FloatingActionButton(heroTag:null,backgroundColor:Colors.blueAccent,onPressed:(){},child:Text("Simulate",style:TextStyle(color: Colors.white)))),
                          FloatingActionButton(heroTag:null,tooltip:"add new body",child:Icon(Icons.add,size:30),onPressed:(){n+=1;simdata[simtitle].add(BodyDetails("Body $n",[],[],[0,0,0]));widget.user!=" "?snapshot.data!.put('userdata',simdata):snapshot.data!.put('data_of_computer',simdata);setState((){});}),
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