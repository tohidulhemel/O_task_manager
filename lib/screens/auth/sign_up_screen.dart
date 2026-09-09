import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/screens/auth/login_screen.dart';
import 'package:task_manager/services/api_caller.dart';
import 'package:task_manager/core/constants/urls.dart';
import 'package:task_manager/widgets/common/screen_bg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onTapSignUP() async {
    final ApiResponse response = await ApiCaller.postRequest(
      url: TMUrls.SignUpURL,
      body: {
        "email": emailController.text,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "mobile": mobileController.text,
        "password": passwordController.text,
      },
    );

    if (response.isSuccess) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 150),
                Text(
                  'Join with us',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Email'),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter email';
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(hintText: 'First Name'),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(hintText: 'Last name'),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(hintText: 'Mobile'),
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                ),

                SizedBox(height: 20),

                FilledButton(
                  onPressed: () {
                    onTapSignUP();
                  },
                  child: Icon(Icons.arrow_forward_ios_sharp, size: 20),
                ),

                SizedBox(height: 70),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Already have an account ?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: ' Sign In',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),

                              recognizer: TapGestureRecognizer()
                                ..onTap = onTapSignUP,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
