import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:simple_todo_app/data/database.dart';
import 'package:simple_todo_app/utils/dialog_box.dart';
import 'package:simple_todo_app/utils/todo_tiles.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();
  final _controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadDatabase();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
    _vibrate();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
    _vibrate();
  }

  void createNewtask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            saveNewTask();
            _vibrate();
          },
          onCancel: () {
            Navigator.of(context).pop();
            _vibrate();
          },
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
    _vibrate();
  }

  void _vibrate() {
    Vibrate.feedback(
      FeedbackType.light,
    ); // You can adjust the type of haptic feedback
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text('TO DO LIST'),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNewtask();
          _vibrate();
        },
        child: Icon(Icons.add),
      ),
      body: db.toDoList.isEmpty
          ? Center(
              child: Text(
                'No tasks yet. Add a task using the "+" button.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: db.toDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.toDoList[index][0],
                  taskCompleted: db.toDoList[index][1],
                  onChanged: (value) {
                    checkBoxChanged(value, index);
                    _vibrate();
                  },
                  deleteFunction: (context) {
                    deleteTask(index);
                    _vibrate();
                  },
                );
              },
            ),
    );
  }
}
