import 'package:flutter/material.dart';
//import 'package:build_runner/build_runner.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'login.dart';
import 'sim_para.dart';
import 'bodyclass.dart';
/*part 'main.g.dart';

@HiveType(typeId: 0)
class BodyDetails extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  List<double> lastValue;
  @HiveField(2)
  List<double> lastVelocities;
  @HiveField(3)
  List<double> lastAcceleration;
  BodyDetails(this.name,this.lastValue,this.lastVelocities,this.lastAcceleration);
}*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BodyDetailsAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuckkkkkkk',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 35, 35, 35),
        ),
      ),
      home: const MyHomePage(title: 'N body Simulation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Future<void> func(BuildContext context){
    return showDialog(
      context:context,
      builder:  (BuildContext context){
        return AlertDialog(
          contentPadding:EdgeInsets.all(20),
          title:Text("LOGOUT?",style:TextStyle(color:Color.fromARGB(255, 39, 129, 202),fontSize:25)),
          content:Text("are you sure to logout ",style:TextStyle(color:Colors.black,fontSize:18)),
          actions:[
            OutlinedButton(child:Text("confirm"),onPressed:(){setState((){user=" ";});Navigator.of(context).pop();}),
            OutlinedButton(child:Text("cancel"),onPressed:(){Navigator.of(context).pop();})
          ]
        );
      } 
    );
  }
  
  
  Future func2(BuildContext context ,index, data){return showDialog<Map> (
    context:context,
    builder:(context){return AlertDialog(
      contentPadding:EdgeInsets.all(20),
      title:Text("Delete?",style:TextStyle(color:Color.fromARGB(255, 39, 129, 202),fontSize:25)),
      content:Text("are you sure to delete this simulation including its data ",style:TextStyle(color:Colors.black,fontSize:18)),
      actions:[
        OutlinedButton(child:Text("confirm"),onPressed:(){data.remove(data.keys.toList()[index]);Navigator.of(context).pop(data);}),
        OutlinedButton(child:Text("cancel"),onPressed:(){Navigator.of(context).pop(data);})
      ]
    );}
    
  );}
  Future funcAddSim(BuildContext context,data,user )async{
    return showDialog(
      context:context,
      builder:(context){
        int show=1;
        String texti='';
        return FutureBuilder(
          future:future,
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              return StatefulBuilder(
                builder:(context, setStateDialog){
                  //return FutureBuilder
                  return AlertDialog(
                    title:Text("Add Title"),
                    actions:[
                      TextField(
                        style:TextStyle(color:Colors.black,fontSize:20),
                        onChanged:(text){
                          
                          if (text.isEmpty){
                            show=1;
                          }
                          else if ( data.keys.toList().contains(text)){
                            show=2;
                          }
                          else{
                            texti=text;
                            show=0; 
                            //setState((){});
                          }
                          setStateDialog((){});
                        }
                      ),
                      if (show!=0)Icon(Icons.error),
                      if(show==1) Text("the title cant be empty"),
                      if (show==2) Text("you have already used this title in your simulations"),
                      OutlinedButton(child:Text("cancel"),onPressed:(){Navigator.of(context).pop();}),
                      if (show==0) OutlinedButton(child:Text("Create"),onPressed:(){
                        data[texti]=[BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])];
                        setStateDialog((){});
                        setState((){});
                        user != " "?snapshot.data!.put('userdata',data):snapshot.data!.put('data_of_computer',data);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return Sim_para(user:user,title:texti,coordinates:data[texti],data:data);
                        }));
                      })
                    ]
                  );
                } ,
              );
            }
            else{
              return Column(
                children: <Widget>[
                  CircularProgressIndicator(strokeWidth: 30, color: Colors.blue),
                  Text(
                    "Loading",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              );
            }
          },
        );
        
        
      }
    );
  }   
    
  
  String user = " ";

  late Future<Box> future;
  @override
  void initState() {
    super.initState();
    future = Hive.openBox('data');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          /*Map<String, List<dynamic>> dataComputer = snapshot.data!.get(
            'data_of_computer',
            defaultValue: {'ssc': [BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])]},
          );
            //setState((){});
          */
          Map<String, List<dynamic>> data = user != " "? snapshot.data!.get(
            'userdata',
            defaultValue: {'ss': [BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])]},
          ):snapshot.data!.get(
            'data_of_computer',
            defaultValue: {'ssc': [BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])]},
          );
          
          //Map<String, List<dynamic>> data =dataComputer;// change this 
          //final keysc = dataComputer.keys.toList();
          //final valuesc = dataComputer.values.toList();
          final keys = data.keys.toList();
          final values = data.values.toList();
          print(data);
          return Scaffold(
            appBar: AppBar(
              actionsPadding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
              backgroundColor: const Color.fromARGB(255, 35, 35, 35),
              leading: Image(image: AssetImage("assets/images/aac_logo.png")),
              title: Text(
                widget.title,
                style: TextStyle(
                  color: Color.fromARGB(255, 39, 129, 202),
                  fontSize: 40,
                ),
              ),
              actions: <Widget>[
                Text(
                  "Welcome, $user",
                  style: TextStyle(
                    color:  Colors.white,
                    fontSize:20
                  ),
                ),
                if (user!=" ") OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    func(context);
                    if (user==" "){snapshot.data!.put('userdata',{'ssc':[]});data=snapshot.data!.get('data_of_computer',defaultValue: {'ssc': [BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])]});setState((){});}
                  },
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), //shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                SizedBox(width: 10),
                if (user==" ") FloatingActionButton(
                  heroTag: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  onPressed: () async {
                    final datas = (await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Login(title: "hi"),
                      ),
                    ));
                    data=datas.values.toList()[0];
                    user=datas.keys.toList()[0];
                    snapshot.data!.put('userdata', data);
                    setState(() {});
                  },
                  tooltip: "login to view your simulations",
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                if (user==" ") FloatingActionButton(
                  heroTag: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  onPressed: () async {
                    final datas = (await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Login(title: "hi"),
                      ),
                    ));
                    data=datas.values.toList()[0];
                    user=datas.keys.toList()[0];
                    
                    snapshot.data!.put('userdata', data);
                    setState(() {});
                  },
                  tooltip: "Make an account",
                  child: Text(
                    "Signup",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  left: 120,
                  right: 120,
                  top: 80,
                  bottom: 50,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/background_main.png"),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha:0.65),
                      borderRadius: BorderRadius.circular(10),
                      border: BoxBorder.all(width: 1, color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        Text(
                          textAlign: TextAlign.end,
                          "ABOUT",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),

                        AppBar(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          centerTitle: true,
                          backgroundColor: Colors.white.withValues(alpha:0.8),
                          title: Text(
                            "Your Simulations",
                            style: TextStyle(
                              color: const Color.fromARGB(255, 14, 106, 182),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          actions: [
                            //DropdownButton(icon:Icon(weight:5,color:Colors.black,size:35,Icons.sort),onChanged:(){},items:),
                            IconButton(
                              splashColor: Colors.green,
                              tooltip: "Create New Simulation",
                              icon: Icon(
                                weight: 5,
                                color: Colors.black,
                                size: 35,
                                Icons.add,
                              ),
                              onPressed: ()async{await funcAddSim(context,data,user);setState((){});}
                            ),
                          ],
                        ),
                        if ((user!=" " && data=={'ss':  [BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])]})||(user==" " && data=={'ssc':  [BodyDetails('Body 1',[],[],[0,0,0]),BodyDetails('Body 2',[],[],[0,0,0])]}))
                          SizedBox(
                            child: Text(
                              "You Have No Simulations",
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 121, 121, 121),
                              ),
                            ),
                          )
                          //data={};

                          //setState{(){}};
                        else if (user!=" " && data.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: Material(
                              color: Colors.transparent,
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),

                                itemCount: keys.length,
                                itemBuilder: (context, index) => ListTile(
                                  //leading:add a sim image,
                                  minTileHeight: 30,
                                  //dense:true,
                                  tileColor: Colors.white,
                                  splashColor: Colors.green,
                                  selectedColor: Colors.red,
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async{
                                      final datas =await func2(context, index,data);
                                      data=datas;
                                      setState((){});
                                      snapshot.data!.put('userdata',data);
                                    },
                                  ),
                                  title: Text(
                                    keys[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () async{
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return  Sim_para(
                                            user:user,
                                            title: keys[index].toString(),
                                            coordinates: values[index],
                                            data:data
                                    
                                          );
                                          
                                        }
                                      ),
                                    );
                                    setState((){});
                                  },
                                ),
                              ),
                            ),
                          )
                        else if (user==" " && data.isNotEmpty) //dataComputer
                          SizedBox(
                            height: 200,
                            child: Material(
                              color: Colors.transparent,
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),

                                itemCount: keys.length,
                                itemBuilder: (context, index) => ListTile(
                                  //leading:add a sim image,
                                  minTileHeight: 30,
                                  //dense:true,
                                  tileColor: Colors.white,
                                  splashColor: Colors.green,
                                  selectedColor: Colors.red,
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () async{
                                      final datas =await func2(context, index,data);
                                      data=datas;
                                      setState((){});
                                      snapshot.data!.put('data_of_computer',data);
                                    },
                                  ),
                                  title: Text(
                                    keys[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () async{
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Sim_para(
                                          user:user,
                                          title: keys[index].toString(),
                                          coordinates: values[index],
                                          data:data
                                        ),
                                      ),
                                    );
                                    setState((){});
                                  },
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            child: Text(
                              "You Have No Simulations",
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 121, 121, 121),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
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
