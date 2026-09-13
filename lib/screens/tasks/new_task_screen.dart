import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/models/task_status_count_model.dart';
import 'package:task_manager/services/api_caller.dart';
import 'package:task_manager/core/constants/urls.dart';
import 'package:flutter/material.dart';

import '../../widgets/task/task_card.dart';
import '../../widgets/task/task_card_count.dart';
import 'add_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTaskCount();
    getTask('New');
  }

  List<TaskStatusCountModel> taskCountByStatus = [];
  List<TaskModel> taskList = [];

  Future<void> getTask(String status) async {
    final ApiResponse response = await ApiCaller.getRequest(
      url: TMUrls.taskListByStatusURL(status),
    );

    List<TaskModel> tList = [];

    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        tList.add(TaskModel.fromJson(jsonData));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.responseData['data'])));
    }

    setState(() {
      taskList = tList;
    });
  }

  Future<void> getAllTaskCount() async {
    final ApiResponse response = await ApiCaller.getRequest(
      url: TMUrls.taskStatusCountURL,
    );

    List<TaskStatusCountModel> taskCount = [];

    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        taskCount.add(TaskStatusCountModel.fromJson(jsonData));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.responseData['data'])));
    }

    setState(() {
      taskCountByStatus = taskCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: taskCountByStatus.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 120,
                  child: TaskCardCount(
                    title: taskCountByStatus[index].sId.toString(),
                    count: taskCountByStatus[index].sum!.toInt(),
                  ),
                );
              },

              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 5);
              },
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: taskList[index],
                  cardColor: Colors.blue,
                  refreshParent: () {
                    getAllTaskCount();
                    getTask('New');
                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNewTaskScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
