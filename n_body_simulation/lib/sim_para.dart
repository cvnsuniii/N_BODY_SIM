import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(); 
  }
}