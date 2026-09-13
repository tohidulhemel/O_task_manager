import 'package:task_manager/database/task_database.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/widgets/common/tm_appbar.dart';
import '../../models/task.dart';

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTask();
  }

  List<Task> tasks = [];

  Future<void> refreshTask() async {
    tasks = await TaskDatabase.getTask();
    setState(() {});
  }

  Future<void> deleteTask(int id) async {
    await TaskDatabase.deleteTask(id);
    refreshTask();
  }

  Future<void> toggleTask(Task task) async {
    await TaskDatabase.updateTask(
      Task(id: task.id, title: task.title, isDone: !task.isDone),
    );
    refreshTask();
  }

  Future<void> addTask() async {
    if (taskController.text.isNotEmpty) {
      await TaskDatabase.insertTask(
        Task(title: taskController.text, isDone: false),
      );
      taskController.clear();
      refreshTask();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TmAppBar( ),
 
      body: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: taskController)),
              IconButton(
                onPressed: () {
                  addTask();
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      toggleTask(task);
                    },
                  ),
                  title: Text(task.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.edit, color: Colors.orange),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteTask(task.id!);
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
