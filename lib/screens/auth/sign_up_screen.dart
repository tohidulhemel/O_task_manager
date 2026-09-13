
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
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController firstNameController =
      TextEditingController();

  final TextEditingController lastNameController =
      TextEditingController();

  final TextEditingController mobileController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> onTapSignUP() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final ApiResponse response =
        await ApiCaller.postRequest(
      url: TMUrls.SignUpURL,
      body: {
        "email": emailController.text.trim(),
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "mobile": mobileController.text.trim(),
        "password": passwordController.text,
      },
    );

    if (response.isSuccess) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.responseData['message'] ??
                'Sign up failed',
          ),
        ),
      );
    }
  }

  void onTapSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool keyboardOpen =
        MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 35.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: keyboardOpen ? 50 : 150,
                ),

                Text(
                  'Join with us',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                SizedBox(
                  height: keyboardOpen ? 10 : 20,
                ),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'Please Enter email';
                    }

                    return null;
                  },
                ),

                SizedBox(
                  height: keyboardOpen ? 8 : 10,
                ),

                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                  ),
                ),

                SizedBox(
                  height: keyboardOpen ? 8 : 10,
                ),

                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    hintText: 'Last name',
                  ),
                ),

                SizedBox(
                  height: keyboardOpen ? 8 : 10,
                ),

                TextFormField(
                  controller: mobileController,
                  decoration: const InputDecoration(
                    hintText: 'Mobile',
                  ),
                ),

                SizedBox(
                  height: keyboardOpen ? 8 : 10,
                ),

                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),

                SizedBox(
                  height: keyboardOpen ? 12 : 15,
                ),

                FilledButton(
                  onPressed: onTapSignUP,
                  child: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 25,
                  ),
                ),

                Expanded(
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account ?",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        children: [
                          TextSpan(
                            text: ' Sign In',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = onTapSignIn,
                          ),
                        ],
                      ),
                    ),
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