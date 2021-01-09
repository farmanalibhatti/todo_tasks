import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_tasks/models/todo.dart';
import 'package:todo_tasks/pages/LoginPage.dart';
import 'package:todo_tasks/services/todo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  String _newTodo = '';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $_displayName'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              signout();
            },
          ),
        ],
        // title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(50, 50, 50, 0.09),
              ),
              height: 550,
              child: Consumer<TodoService>(
                builder: (context, value, child) => Container(
                  height: 550.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(50, 50, 50, 0.09),
                  ),
                  child: ListView.builder(
                    itemCount: value.todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          context
                              .read<TodoService>()
                              .removeTodo(value.todos[index].id);
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${value.todos[index].title} dismissed.'),
                            ),
                          );
                          // setState(() {
                          //   todos.removeAt(index);
                          // });
                        },
                        child: Card(
                          shadowColor: Colors.deepOrangeAccent[100],
                          child: ListTile(
                            title: Text(value.todos[index].title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.deepOrange,
                                  ),
                                  onPressed: () {
                                    // Update Todo
                                    TextEditingController _textController =
                                        TextEditingController(
                                      text: value.todos[index].title,
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Update Todo"),
                                          content: TextField(
                                            onChanged: (String value) {
                                              _newTodo = value;
                                            },
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                var tempTodo = Todo(
                                                    title:
                                                        _textController.text);
                                                tempTodo.id =
                                                    value.todos[index].id;
                                                context
                                                    .read<TodoService>()
                                                    .updateTodo(tempTodo);
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Update"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Text('Welcome $_displayName'),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add Todo
          TextEditingController _textController = TextEditingController();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Todo"),
                content: TextField(
                  controller: _textController,
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      context.read<TodoService>().addTodo(
                            Todo(
                                title:
                                    _textController.text ?? "Title is empty."),
                          );
                      Navigator.of(context).pop();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
