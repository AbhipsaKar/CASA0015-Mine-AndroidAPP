import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}
class LoginState extends State<Login> {
  TextEditingController usernamec = TextEditingController();
  TextEditingController passwordc = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MINE"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.black54,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(2.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 50),
                            TextFormField(
                              controller: usernamec,
                              decoration: InputDecoration(
                                  hintText: 'Username',
                                  labelText: 'Username',
                                  contentPadding: const EdgeInsets.all(25),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0)
                                  )
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: passwordc,
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: '*******',
                                  labelText: 'Password',
                                  contentPadding: EdgeInsets.all(25),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0)
                                  )
                              ),
                            ),
                            const SizedBox(height: 25),
                            MaterialButton(
                              padding: EdgeInsets.fromLTRB(12.0, 14.0, 12.0, 14.0),
                              color: Colors.lightGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w900),
                              ),
                              onPressed: () {

                                _performLogin() async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString("username", usernamec.text);
                                  prefs.setBool("isLoggedIn", true);
                                  Navigator.pushNamed(context,'/');
                                  /*Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage()
                                      )
                                  );*/
                                }

                                _performLogin();


                              },

                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.rectangle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: const AssetImage('assets/homepage.png'),
                      opacity:0.3,
                  )
              ),
            ),
          ),
        ],
      ),
    );

  }
}