import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/screens/navigation/main_nav_screen.dart';
import 'package:task_manager/screens/auth/sign_up_screen.dart';
import 'package:task_manager/services/api_caller.dart';
import 'package:task_manager/core/constants/urls.dart';
import 'package:task_manager/widgets/common/screen_bg.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 150),
              Text(
                'Get Started with',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
              SizedBox(height: 25),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),

              SizedBox(height: 20),

              FilledButton(
                onPressed: () async {
                  final ApiResponse response = await ApiCaller.postRequest(
                    url: TMUrls.LoginURL,
                    body: {
                      "email": emailController.text,
                      "password": passwordController.text,
                    },
                  );

                  if (response.isSuccess) {
                    UserModel model = UserModel.fromJson(
                      response.responseData['data'],
                    );
                    String token = response.responseData['token'];

                    AuthController.saveUserData(model, token);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainNavScreen()),
                    );
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainNavScreen()),
                  );
                },
                child: Icon(Icons.arrow_forward_ios_sharp, size: 20),
              ),

              SizedBox(height: 70),
              Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forget password..?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    RichText(
                      text: TextSpan(
                        text: "Don't have an account ?",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: ' Sign up',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = onTapSignUp,
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
    );
  }
}
