import 'package:flutter/material.dart';
import "main.dart";
import 'bodyclass.dart';

// ignore: camel_case_types
class Sim_para extends StatefulWidget {
  const Sim_para({super.key, required this.title, required this.coordinates,required this.data});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List coordinates ;
  final Map data;
  
  @override
  State<Sim_para> createState() => Simparastate();
}
class Simparastate extends State<Sim_para> {
  // ignore: non_constant_identifier_names
  late String Simtitle;
  int valNoBody=0;
  int n=2;
  double offsetY = 1;   // Start off-screen (bottom)
  bool titledit=false;
  bool errortitle=false; 
  @override
  void initState() {
    super.initState();
    Simtitle=widget.title;
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        offsetY = 0;   // Slide to normal position
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading:FloatingActionButton(onPressed:( (){Navigator.of(context).pop();})),
        title:Text("Simulation Parameters",style:TextStyle(color:Colors.black,fontSize:30))
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
                    if (!titledit)Text(Simtitle,style:TextStyle(fontSize:25,color:Colors.black)),
                    if(!titledit) IconButton(icon:Icon(Icons.edit),onPressed:(){titledit=!titledit;setState((){});}),
                    if (titledit) Text("Enter your title here ",style:TextStyle(fontSize:25,color:Colors.black)),
                    if(titledit) SizedBox(width:200,child:TextField(
                      
                        onChanged: (String text){
                          if (widget.data.keys.toList().contains(text)&& text !=Simtitle){
                            errortitle=true;
                            setState((){});
                          }
                          
                          else{
                            errortitle=false;
                            setState((){});
                          }
                        },                      
                        onSubmitted:(String text){
                          
                          if (errortitle){
                            //print(text);print(widget.title);print(widget.data['ss']);print(widget.data[widget.title]);
                            widget.data[text]=widget.data[Simtitle];
                            widget.data.remove(Simtitle);
                            Simtitle=text;
                            titledit=!titledit;
                            //print(widget.data);
                            setState((){});
                            //State<MyHomePage>.snapshot.data!.put('userdata',widget.data);
                          }
                        }
                      ),
                    ),
                    if (titledit &&errortitle) Icon(Icons.error),
                    if (titledit &&errortitle) Text("you have already used this") ,
                    if (titledit &&errortitle) Text("title cannot be empty") 
                  ],)),
                  
                  Row(spacing:20,children: [
                    Text("Number of Bodies",style:TextStyle(color:Colors.black,fontSize:20)),
                    SizedBox(
                      width:200,
                      child:TextField(
                        style:TextStyle(color:Colors.white,fontSize:20),
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
                        //onSubmitted:(){},
                      ),
                    ),
                    SizedBox(width: 100,),
                    if (valNoBody==1||valNoBody==2) Icon(Icons.dangerous,color:Colors.red),
                    if (valNoBody==1) Text("invalid number type.please enter a integer",style:TextStyle(color:Colors.black,fontSize:14)),
                    if(valNoBody==2) Text("Input cant be negative or less than 2",style:TextStyle(color:Colors.black,fontSize:14)),
                  ],),
                  Row(spacing:20,children:[SizedBox(width:100),Icon(Icons.info,size:15),Text("Press Enter to validate the number of bodies")]),
                  SizedBox(height:30),
                  for(int i=0; i<n; i++) 
                  FloatingActionButton(backgroundColor:Colors.amberAccent,child:Icon(Icons.add,size:30),onPressed:(){n+=1;widget.coordinates.add(BodyDetails("Body $n",[],[],[0,0,0]));setState((){});})
                ],)
              ) ,
            ),
          )
        )
      )
    ); 
  }
}