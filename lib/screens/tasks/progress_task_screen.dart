import 'package:flutter/material.dart';

import '../../models/api_response.dart';
import '../../models/task_model.dart';
import '../../services/api_caller.dart';
import '../../core/constants/urls.dart';
import '../../widgets/task/task_card.dart';
class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTask('Progress');
  }

  List<TaskModel> taskList = [];

  Future <void> getTask(String status) async {
    final ApiResponse response= await ApiCaller.getRequest(url: TMUrls.taskListByStatusURL(status));

    List<TaskModel> tList= [];

    if(response.isSuccess){
      for(Map<String,dynamic>jsonData in response.responseData['data']){
        tList.add(TaskModel.fromJson(jsonData));
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.responseData['data'])));

    }

    if(mounted){
      setState(() {
        taskList = tList;
      });
    }



  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(

          itemCount: taskList.length,
          itemBuilder: (context,index){
          return TaskCard(taskModel: taskList[index], cardColor: Colors.purple, refreshParent: () {  },);
          }
      ),
    );
  }
}
