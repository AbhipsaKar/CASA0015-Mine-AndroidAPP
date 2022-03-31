import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'tracker.dart';
import 'package:provider/provider.dart';
import 'todolist.dart' ;

void main() {

  SdkContext.init(IsolateOrigin.main);
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(notes: [],markers: [], persons: []), //Change notes to required parameter and initialise to empty array
    child: MyApp(),
  ));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key) ;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool isLoggedIn = false;

  String? username;
  SharedPreferences? prefs;
  List<String>? notes;
  List<String>? people;

  void sharedPreferenceInit () async{
    prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs!.getBool("isLoggedIn")!;
    username = prefs!.getString("username");
    notes = prefs!.getStringList("noteList");
    people = prefs!.getStringList("persons");
    setState(() {
      Provider.of<AppState>(context, listen: false).setLoginState(isLoggedIn);
      Provider.of<AppState>(context, listen: false).setId(username.toString());
      if(notes != null) {
        Provider.of<AppState>(context, listen: false).setNotes(notes as List<String>);
      }
      if(people != null ) {
        Provider.of<AppState>(context, listen: false).addPersons(people as List<String>);
      }

    });

  }

  @override
  void initState() {
    super.initState();
    sharedPreferenceInit();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Welcome to MINE"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              (isLoggedIn == true)?'You are logged in as: $username': 'You are Logged Out',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Visibility(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 250,
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment(0, 0.8),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => const PlaceTrackerApp()
                              )
                          );
                        },
                        child: const Text('Tracking')

                    ),

                    decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: const AssetImage('assets/track.png')
                        )
                    ),
                  ),
                  Container(
                    height: 250,
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment(0, 0.8),
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => ToDoListApp()
                              )
                          );
                        },
                        child: const Text('To do list')

                    ),

                    decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: const AssetImage('assets/todo.png')
                        )
                    ),
                  ),

                  ]
                ),
               visible: isLoggedIn,
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(isLoggedIn == true){
            _performLogout(){
              prefs!.remove("username");
              prefs!.setBool("isLoggedIn", false);
              sharedPreferenceInit();
              setState(() {
              });
            }

            _performLogout();
          }else{
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login()
                )
            );
          }
        },
        tooltip: 'Increment',
        child: Icon((isLoggedIn == true)?Icons.logout: Icons.login),
      ),
    );
  }
}