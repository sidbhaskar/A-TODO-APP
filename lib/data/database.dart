import 'package:hive/hive.dart';

class ToDoDatabase {
  List toDoList = [];
  //reference the box
  final _myBox = Hive.box('mybox');

  //run this method 1st time opening the app
  void createInitialData() {
    toDoList = [
      ['Homework', false],
      ['Sleep', false],
    ];
  }

  //load the data form the database
  void loadDatabase() {
    toDoList = _myBox.get("TODOLIST");
  }

  // update database
  void updateDatabase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
