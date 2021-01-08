import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_tasks/pages/LoginPage.dart';
// Pages
import 'package:todo_tasks/pages/TodosPage.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password, _name;
  // Check user authentication
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodosPage(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  // Sign up user
  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          User updateUser = FirebaseAuth.instance.currentUser;
          updateUser.updateProfile(displayName: _name);
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(e),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      debugPrint("Can not validate!");
    }
  }

  // Text editing controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Sample App'),
      // ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'TODO TASKS',
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: nameController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Enter valid name";
                            }
                            decoration:
                            InputDecoration(
                              labelText: "Name",
                              prefixIcon: Icon(Icons.account_circle),
                            );
                            // onSaved:
                            // (input) => _email = input;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Name',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: emailController,
                          validator: (input) {
                            if (input.isEmpty ||
                                !input.contains("@") ||
                                !input.contains(".")) {
                              return "Enter valid email";
                            }
                            decoration:
                            InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email),
                            );
                            // onSaved:
                            // (input) => _email = input;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: TextFormField(
                          obscureText: true,
                          controller: passwordController,
                          validator: (input) {
                            if (input.length < 6) {
                              return "Provide minimum 6 characters.";
                            }
                            decoration:
                            InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock),
                            );
                            obSecureText:
                            true;
                            // onSaved:
                            // (input) => _password = input;
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  //forgot password screen
                },
                textColor: Colors.deepOrange,
                child: Text('Forgot Password'),
              ),
              Container(
                  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Colors.deepOrange,
                    child: Text('Register'),
                    onPressed: () {
                      _name = nameController.text;
                      _email = emailController.text;
                      _password = passwordController.text;
                      signUp();
                      print(nameController.text);
                      print(emailController.text);
                      print(passwordController.text);
                    },
                  )),
              Container(
                child: Row(
                  children: <Widget>[
                    Text('Already have an account?'),
                    FlatButton(
                      textColor: Colors.deepOrange,
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
