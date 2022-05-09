
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'tracker.dart' ;
import 'package:intl/intl.dart';



class ToDoListApp extends StatelessWidget {
  ToDoListApp({Key? key}) : super(key: key);
  String? note;

  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
            child: IconButton(
              icon: Icon(
                //Toggle button
                Icons.home,
                size: 32.0,
              ),
              onPressed: () {
                //Navigator.pop(context);
                Navigator.popUntil(context, ModalRoute.withName('/'));

              },
            ),
          ),
          title: const Text('To-Do list'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.black54,
        ),
        body: const Center(
            child: RandomNotes()
        ),

    );
  }
}

class RandomNotes extends StatefulWidget {
  const RandomNotes( {Key? key}) : super(key: key);


  @override
  _RandomWordsState createState() => _RandomWordsState();
}


class _RandomWordsState extends State<RandomNotes> {

  final _suggestions = <String>{};
  final _biggerFont = TextStyle(fontSize: 16, fontFamily: 'Times', color: Colors.blueGrey);


  @override
  Widget build(BuildContext context) {

    final note = List<String>.from(Provider.of<AppState>(context, listen:false).notes);
    print("Length of list");
    print(note.length);
    final isNoteExist = note.length > 0? true: false;
    if(isNoteExist) {
      _suggestions.addAll(note);
    }

    return Scaffold(

      body: isNoteExist? _buildNoteRows() : _buildblankNote() ,
      floatingActionButton: Wrap( //will break to another line on overflow
        direction: Axis.horizontal, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
            margin:EdgeInsets.all(20),
            child: FloatingActionButton(
              onPressed: () {
                            Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) =>  AddNotePage(noteList: _suggestions.toList())
                              )
                            );
              },
              tooltip: 'Add note',
              child: const Icon(Icons.add, color: Colors.white60),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          ),

        ],),
    );

  }
  Widget _buildblankNote () {

    return Container(
        margin:EdgeInsets.symmetric(horizontal: 20.0,vertical: 50.0),
        child: const Text(
            "No notes. Pls click on + button",
            style: TextStyle(fontSize: 24, fontFamily: 'Times', color: Colors.black),

          ),
        decoration: BoxDecoration(
          color: Colors.lightGreen.withOpacity(0.2), // Your desired background color
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
          ]
      ),
    );
  }

  Widget _buildNoteRows () {

    return ListView.builder(
      padding: const EdgeInsets.all(16),

      itemCount: _suggestions.length,
      itemBuilder: (context, i) {

        print("build row");
        print(i);
        return _buildRow(_suggestions.elementAt(_suggestions.length-i-1));
      },
    );
  }

  Widget _buildRow(String note) {

    return Container(
    margin:EdgeInsets.symmetric(horizontal: 2.0,vertical: 8.0),
    child: ListTile(
      title: Text(
        note,
        style: _biggerFont,

      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.blueGrey,
        ),
      ),
      tileColor: Colors.lightGreen.withOpacity(0.2),
      style: ListTileStyle.drawer,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
      leading: const Image(image: AssetImage('assets/icon0.png')),
      trailing: const Icon( // NEW from here...

        Icons.delete_rounded,
        semanticLabel: 'Remove from saved',
      ),
      onTap: () {
        _removeNote () async{
          _suggestions.remove(note);
          SharedPreferences? prefs;
          prefs = await SharedPreferences.getInstance();

          prefs!.setStringList("noteList", _suggestions.toList());
          Provider.of<AppState>(context, listen: false).setNotes(_suggestions.toList());
        }
        setState (() {
          _removeNote();
        });
      },
    ));
  }


}

class AddNotePage extends StatefulWidget {
  final List<String> noteList;

  const AddNotePage( {Key? key , required this.noteList}) : super(key: key);


  @override
  _AddNotePageState createState() => _AddNotePageState(noteList);
}

class _AddNotePageState extends State<AddNotePage> {
  late final List<String> noteList ;
  final _titleFont = TextStyle(fontSize: 20, fontFamily: 'Times', color: Colors.blueGrey);
  final _itemFont = TextStyle(fontSize: 18, fontFamily: 'Times', color: Colors.black38);

  _AddNotePageState(List<String> noteList1)
  {
    noteList = noteList1;
  }
  final TextEditingController note = TextEditingController();
  String getFirstPerson()
  {
    var persons = List<String>.from(Provider.of<AppState>(context, listen:false).persons);
    return persons.first;
  }

  String selectedValue = "";
  List<DropdownMenuItem<String>> get buildDropdownTestItems{
    final personList = List<String>.from(Provider
        .of<AppState>(context, listen: false)
        .persons);
    final username = Provider
        .of<AppState>(context, listen: false)
        .id;
    print(personList);

    if (personList.isEmpty || (!(personList.contains(username)))) {
      personList.add(username);
    }
    //var persons = List<String>.from(Provider.of<AppState>(context, listen:false).persons);
    var menuItems = <DropdownMenuItem<String>> [];
    for (var item in personList)
    {
      DropdownMenuItem<String> menuItem = DropdownMenuItem(child: Text(item,style: _itemFont,),value: item);
      menuItems.add(menuItem);
    }

    return menuItems;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black54,
      ),
      body: Container(
              decoration: BoxDecoration(
                  color: Colors.lightGreen.withOpacity(0.1), // Your desired background color
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15),
                  ]
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 30),
                          Row(
                            children:<Widget>[
                              Text("Select recipient ",style: _titleFont),
                              const SizedBox(width: 40),
                              DropdownButton(
                                value: selectedValue == ""?getFirstPerson():selectedValue,
                                onChanged: (String? newValue){
                                  print("Change recipient");
                                  print(newValue);
                                  selectedValue = newValue!;
                                  setState(() {});  //Refresh widget

                                },
                                  elevation: 10,
                                dropdownColor: Colors.lightGreen.withOpacity(0.8),
                                items: buildDropdownTestItems
                              ),
                            ]
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children:<Widget>[
                              Text("Enter Note: ",style: _titleFont,textAlign: TextAlign.left,),
                              const SizedBox(width: 40),
                              ]),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: note,
                            decoration: InputDecoration(
                                labelText: 'Note',
                                contentPadding: const EdgeInsets.all(25),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.0)
                                )
                            ),
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 100),
                          MaterialButton(
                            padding: EdgeInsets.fromLTRB(12.0, 14.0, 12.0,
                                14.0),
                            color: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              _addNote() async {
                                    var now = new DateTime.now();
                                    var formatter = new DateFormat('dd-MM-yyyy');
                                    String formattedTime = DateFormat('kk:mm a').format(now);
                                    String formattedDate = formatter.format(now);
                                    print(formattedTime);
                                    print(formattedDate);
                                    //var now = new DateTime.now();
                                    String finaltxt = "To: "+ selectedValue + "\n" + note.text + "\n" + formattedTime + " " + formattedDate;
                                    setState(() {
                                      noteList.add(finaltxt);
                                    });


                                    SharedPreferences? prefs;
                                    prefs = await SharedPreferences.getInstance();
                                    //prefs!.setStringList("trackers", trackers as List<String>);
                                    prefs!.setStringList("noteList", noteList).then((value) =>
                                        {
                                          Navigator.pushNamed(context,'/note')
                                          /*Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => ToDoListApp()
                                            )
                                        )*/
                                      });
                                    Provider.of<AppState>(context, listen: false).setNotes(noteList);

                              }

                              _addNote();
                            },

                          ),
                        ]
                    ),
                  ),
                ),
              ),


    );
  }
}
