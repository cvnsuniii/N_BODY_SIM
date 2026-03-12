import 'package:flutter/material.dart';
import 'package:n_body_simulation/main.dart';
import 'bodyclass.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => Loginstate();
}
class Loginstate extends State<Login> {
  Map<String,Map<String,List<dynamic>>> fuck={'ggg':{'ss': [BodyDetails('Body 1',[0,0,0],[0,0,0],[0,0,0],0,Colors.grey.toARGB32(),1),BodyDetails('Body 2',[0,0,0],[0,0,0],[0,0,0],0,Colors.grey.toARGB32(),1)]}};
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:AppBar(leading:IconButton(icon:Icon(Icons.arrow_back),onPressed:(){Navigator.of(context).pop(fuck);}))); 
  }
}