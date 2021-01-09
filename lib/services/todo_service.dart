import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_tasks/models/todo.dart';
import 'package:todo_tasks/models/todo.dart';

class TodoService with ChangeNotifier {
  final CollectionReference todosCollection =
      FirebaseFirestore.instance.collection('todos');
  List<Todo> todos = [];
  Future<void> loadTodos() async {
    QuerySnapshot incoming_payload = await todosCollection.get();
    print(incoming_payload.runtimeType);
    debugPrint("Length of list: ${incoming_payload.docs.length}");
    incoming_payload.docs.forEach((doc) {
      Todo new_todo = Todo(title: doc['title']);
      todos.add(new_todo);
    });
    debugPrint("Length of todos: ${todos.length}");
  }

  addTodo(Todo todo) async {
    await todosCollection.add({"title": todo.title}).then((value) {
      todo.id = todo.id;
      todos.add(todo);
    });
    // todos.add(todo);
    notifyListeners();
  }

  removeTodo(id) async {
    var index = todos.indexWhere((element) => element.id == id);
    if (index != -1) {
      await todosCollection.doc(id).delete();
      todos.removeAt(index);
    }
    notifyListeners();
  }

  updateTodo(Todo todo) async {
    var index = todos.indexWhere((element) => element.id == todo.id);
    // Update todo and check if todo is in the list
    if (index != -1) {
      await todosCollection.doc(todo.id).update({
        'title': todo.title,
      });
      todos[index] = todo;
    }
    notifyListeners();
  }
}
