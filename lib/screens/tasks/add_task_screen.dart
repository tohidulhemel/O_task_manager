
import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/screens/navigation/main_nav_screen.dart';
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
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController =
      TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen =
        MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: const TmAppBar(
        showBackButton: true,
        enableProfileTap: false,
      ),

      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: keyboardOpen ? 25 : 150,
              ),

              Text(
                'Add new Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: descriptionController,
                maxLines: keyboardOpen ? 3 : 6,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),

              const SizedBox(height: 20),

              FilledButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a task title',
                        ),
                      ),
                    );
                    return;
                  }

                  final ApiResponse response =
                      await ApiCaller.postRequest(
                    url: TMUrls.addNewTaskURL,
                    body: {
                      "title": titleController.text.trim(),
                      "description":
                          descriptionController.text.trim(),
                      "status": "New",
                    },
                  );

                  if (response.isSuccess) {
                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MainNavScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response.responseData['message'] ??
                              'Failed to add task',
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
