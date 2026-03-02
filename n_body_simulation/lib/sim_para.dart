import 'package:flutter/material.dart';
import "main.dart";
// ignore: camel_case_types
class Sim_para extends StatefulWidget {
  const Sim_para({super.key, required this.title, required this.coordinates});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final List coordinates ;
  @override
  State<Sim_para> createState() => Simparastate();
}
class Simparastate extends State<Sim_para> {
  bool val_no_obody=false;
  late func_auto_numbod(nowstr){
    try{
      nowstr.toInt();
      val_no_body=true;
      
    }
    catch{

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading:FloatingActionButton(onPressed:( (){Navigator.of(context).pop();})),
        title:Row(
          children: [
            //if(Sim_para.title=="") IconButton()
          ],
        ),
      ),
      body:Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(bottom:50,right:120,left:120,top:MediaQuery.of(context).size.height),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/background_main.png"),
            ),
          ),
          child:AnimatedPadding(
            duration: Duration(seconds: 5),
            padding:EdgeInsets.only(bottom:50,right:120,left:120,top:80),
            curve:Curves.easeInOutSine,
            child:SingleChildScrollView(
              child:Container(
                width:double.infinity,
                height:200,
                decoration:BoxDecoration(color:Colors.black.withOpacity(0.5),boxShadow:[BoxShadow(spreadRadius:5)]),
                child:Column(children: [
                  Row(children: [Text("Number of Bodies",style:TextStyle()),TextField(onTap:func_auto_numbod(nowstr),onChanged:,)],)
                ],)
              ) ,
            ),
          )
        )
      )
    ); 
  }
}