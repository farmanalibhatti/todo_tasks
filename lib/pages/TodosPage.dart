import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_tasks/pages/LoginPage.dart';

class TodosPage extends StatefulWidget {
  TodosPage({
    Key key,
  }) : super(key: key);
  // final String title;

  @override
  _TodosPageState createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _displayName = '';
  int _counter = 0;
  bool isLoggedIn = false;
  // Check user authentication
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
  }

  // Get user data
  getUser() async {
    User user = await _auth.currentUser;
    await user?.reload();
    user = await _auth.currentUser;
    if (user != null) {
      setState(() {
        this._displayName = user.displayName;
        this.isLoggedIn = true;
      });
    }
  }

  // Signout
  signout() async {
    _auth.signOut();
  }

  // Do this every time the function is invoked
  @override
  void initState() {
    this.checkAuthentication();
    this.getUser();
  }

  // Other
  void _incrementCounter() {
    signout();
    // setState(() {
    //   _counter++;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Tasks'),
        // title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome $_displayName'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
