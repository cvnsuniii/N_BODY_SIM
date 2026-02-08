import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'login.dart';
import 'sim_para.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 35, 35, 35),
        ),
      ),
      home: const MyHomePage(title: 'N body Simulation'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
            OutlinedButton(child:Text("confirm"),onPressed:(){user=" ";Navigator.of(context).pop();setState((){});}),
            OutlinedButton(child:Text("cancel"),onPressed:(){Navigator.of(context).pop();})
          ]
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, List<dynamic>> dataComputer = snapshot.data!.get(
            'data_of_computer',
            defaultValue: {'ssc': []},
          );
          Map<String, List<dynamic>> data = snapshot.data!.get(
            'userdata',
            defaultValue: {'ss': []},
          );
          //Map<String, List<dynamic>> data =dataComputer;// change this 
          final keysc = dataComputer.keys.toList();
          final valuesc = dataComputer.values.toList();
          final keys = data.keys.toList();
          final values = data.values.toList();
          print(data);
          return Scaffold(
            appBar: AppBar(
              actionsPadding: EdgeInsets.only(right: 20, top: 5, bottom: 5),
              // TRY THIS: Try changing the color here to a specific color (to
              // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
              // change color while the other colors stay the same.
              backgroundColor: const Color.fromARGB(255, 35, 35, 35),
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
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
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    func(context);
                    if (user==" "){snapshot.data!.put('userdata',{});}
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
                FloatingActionButton(
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
                    snapshot.data!.put('user_data', data);
                    setState(() {});
                  },
                  tooltip: "login to view your simulations",
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                FloatingActionButton(
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
                      color: Colors.black.withOpacity(0.65),
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
                          backgroundColor: Colors.white.withOpacity(0.8),
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
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Sim_para(
                                      title: "new sim",
                                      coordinates: [],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        if (user!=" " && data.isNotEmpty)
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
                                    onPressed: () {
                                      data.remove(keys[index]);
                                      setState(() {});
                                      snapshot.data!.put('userdata', data);
                                    },
                                  ),
                                  title: Text(
                                    keys[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Sim_para(
                                          title: keys[index].toString(),
                                          coordinates: values[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )
                        else if (user==" " && dataComputer.isNotEmpty)
                          SizedBox(
                            height: 200,
                            child: Material(
                              color: Colors.transparent,
                              child: ListView.builder(
                                padding: EdgeInsets.all(10),

                                itemCount: keysc.length,
                                itemBuilder: (context, index) => ListTile(
                                  //leading:add a sim image,
                                  minTileHeight: 30,
                                  //dense:true,
                                  tileColor: Colors.white,
                                  splashColor: Colors.green,
                                  selectedColor: Colors.red,
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      dataComputer.remove(keysc[index]);
                                      setState(() {});
                                      snapshot.data!.put('data_of_computer', dataComputer);
                                    },
                                  ),
                                  title: Text(
                                    keysc[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Sim_para(
                                          title: keysc[index].toString(),
                                          coordinates: valuesc[index],
                                        ),
                                      ),
                                    );
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
