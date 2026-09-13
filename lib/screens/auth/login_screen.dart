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
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final bool keyboardOpen = keyboardHeight > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: ScreenBG(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,

          padding: EdgeInsets.only(
            left: 35,
            right: 35,

            top: keyboardOpen ? 100 : 200,

            bottom: 20,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get Started with',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),

              const SizedBox(height: 25),

              FilledButton(
                onPressed: () async {
                  // Check empty fields first
                  if (emailController.text.trim().isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter email and password'),
                      ),
                    );
                    return;
                  }

                  final ApiResponse response = await ApiCaller.postRequest(
                    url: TMUrls.LoginURL,
                    body: {
                      "email": emailController.text.trim(),
                      "password": passwordController.text,
                    },
                  );

                  if (response.isSuccess) {
                    UserModel model = UserModel.fromJson(
                      response.responseData['data'],
                    );

                    String token = response.responseData['token'];

                    await AuthController.saveUserData(model, token);

                    if (!mounted) return;

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          response.responseData['message'] ?? 'Login failed',
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(Icons.arrow_forward_ios_sharp, size: 20),
              ),

              const SizedBox(height: 25),

              // This section is allowed to take the remaining space.
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forget password..?',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),

                      RichText(
                        text: TextSpan(
                          text: "Don't have an account ?",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: ' Sign up',
                              style: const TextStyle(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
