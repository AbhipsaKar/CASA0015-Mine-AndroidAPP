
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'tracker.dart' ;




class ToDoListApp extends StatelessWidget {
  ToDoListApp({Key? key}) : super(key: key);
  String? note;

  @override


  @override
  Widget build(BuildContext context) {
    //var wordPair = WordPair.random();
    return MaterialApp(
      title: 'To Do list',
      theme: ThemeData(          // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.grey,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: const Center(
          //child: Text('Hello World'),
          //child: Text(wordPair.asPascalCase),
            child: RandomNotes()
        ),
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
  //final _suggestions = <WordPair>[];                 // NEW
  //final _biggerFont = const TextStyle(fontSize: 18); // NEW
  final _suggestions = <String>{};
  //final _saved = <WordPair>{};     // NEW
  final _biggerFont = TextStyle(fontSize: 18);


  @override
  Widget build(BuildContext context) {
    //final wordPair = WordPair.random();      // NEW
    //return Text(wordPair.asPascalCase);      // NEW

    final note = List<String>.from(Provider.of<AppState>(context, listen:false).notes);
    print("Length of list");
    print(note.length);
    _suggestions.addAll(note);

    return Scaffold( // Add from here...
      appBar: AppBar(
        title: const Text('Startup Name Generator'),

        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>  AddNotePage(noteList: _suggestions.toList())
                  )
              );
            },
            tooltip: 'Add notes',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );

  }


  Widget _buildSuggestions () {

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

    return ListTile(
      title: Text(
        note,
        style: _biggerFont,

      ),
      tileColor: Colors.blueGrey,
      style: ListTileStyle.drawer,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),

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
    );
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
    var persons = List<String>.from(Provider.of<AppState>(context, listen:false).persons);
    var menuItems = <DropdownMenuItem<String>> [];
    for (var item in persons)
    {
      DropdownMenuItem<String> menuItem = DropdownMenuItem(child: Text(item),value: item);
      menuItems.add(menuItem);
    }

    return menuItems;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter text"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 200),
                          DropdownButton(
                              value: selectedValue == ""?getFirstPerson():selectedValue,
                              onChanged: (String? newValue){
                                selectedValue = newValue!;

                              },
                              hint: Text("Select the recipient"),
                              dropdownColor: Colors.black38,
                              items: buildDropdownTestItems
                          ),
                          const SizedBox(height: 200),
                          TextFormField(
                            controller: note,
                            decoration: InputDecoration(
                                hintText: 'Add note',
                                labelText: 'Note',
                                contentPadding: const EdgeInsets.all(25),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3.0)
                                )
                            ),
                            keyboardType: TextInputType.text,
                          ),

                          const SizedBox(height: 25),
                          MaterialButton(
                            padding: EdgeInsets.fromLTRB(12.0, 14.0, 12.0,
                                14.0),
                            color: Colors.black45,
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
                                    String finaltxt = "To: "+ selectedValue + "\n" + note.text + "\n" + now.toString();
                                    setState(() {
                                      noteList.add(finaltxt);
                                    });


                                    SharedPreferences? prefs;
                                    prefs = await SharedPreferences.getInstance();
                                    //prefs!.setStringList("trackers", trackers as List<String>);
                                    prefs!.setStringList("noteList", noteList).then((value) =>
                                        {

                                          Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => ToDoListApp()
                                            )
                                        )
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
            ),
          ),

        ],
      ),
    );
  }
}
