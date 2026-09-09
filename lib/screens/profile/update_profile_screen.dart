import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/models/user_model.dart';
import 'package:task_manager/screens/navigation/main_nav_screen.dart';
import 'package:task_manager/services/api_caller.dart';
import 'package:task_manager/core/constants/urls.dart';
import 'package:task_manager/widgets/common/screen_bg.dart';
import 'package:task_manager/widgets/common/tm_appbar.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> updateProfile() async {
    Map<String, dynamic> requestBody = {
      "email": emailController.text,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "mobile": mobileController.text,
    };

    if (passwordController.text.isNotEmpty) {
      requestBody['password'] = passwordController.text;
    }

    final ApiResponse response = await ApiCaller.postRequest(
      url: TMUrls.ProfileUpdateURL,

      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel model = UserModel(
        sId: AuthController.userData?.sId,
        email: emailController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobile: mobileController.text,
      );

      AuthController.updateUserData(model);
      setState(() {});

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen()),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UserModel user = AuthController.userData!;

    emailController.text = user.email!;
    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    mobileController.text = user.mobile!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppBar(),
      body: ScreenBG(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(height: 100),
                Text(
                  'Update profile',
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
                    updateProfile();
                  },
                  child: Icon(Icons.arrow_forward_ios_sharp, size: 20),
                ),

                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
