import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/screens/navigation/main_nav_screen.dart';
import 'package:task_manager/screens/auth/sign_up_screen.dart';
import 'package:task_manager/services/api_caller.dart';
import 'package:task_manager/core/constants/urls.dart';
import 'package:task_manager/widgets/common/screen_bg.dart';
import 'package:task_manager/widgets/common/tm_appbar.dart';
import 'package:flutter/material.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  void onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(),
      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 150),
              Text(
                'Add new Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: descriptionController,
                maxLines: 6,
                decoration: InputDecoration(hintText: 'Description'),
              ),

              SizedBox(height: 20),

              FilledButton(
                onPressed: () async {
                  final ApiResponse response = await ApiCaller.postRequest(
                    url: TMUrls.addNewTaskURL,
                    body: {
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "status": "New",
                    },
                  );

                  if (response.isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainNavScreen()),
                    );
                  }
                },
                child: Icon(Icons.arrow_forward_ios_sharp, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
