import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/models/api_response.dart';
import 'package:task_manager/models/user_model.dart';
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
  final TextEditingController emailController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final ImagePicker imagePicker = ImagePicker();

  File? selectedImage;

  Future<void> pickProfileImage() async {
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "mobile": mobileController.text.trim(),
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
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        mobile: mobileController.text.trim(),
      );

      await AuthController.updateUserData(model);

      if (!mounted) return;

      Navigator.pop(context);
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.responseData['message'] ?? 'Failed to update profile',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    UserModel user = AuthController.userData!;

    emailController.text = user.email ?? '';
    firstNameController.text = user.firstName ?? '';
    lastNameController.text = user.lastName ?? '';
    mobileController.text = user.mobile ?? '';
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
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: const TmAppBar(
        showBackButton: true,
        showLogout: true,
        enableProfileTap: false,
      ),

      body: ScreenBG(
  child: SingleChildScrollView(
    keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
    padding: const EdgeInsets.symmetric(
      horizontal: 35.0,
      vertical: 25.0,
    ),
    child: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Picture
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: selectedImage != null
                      ? FileImage(selectedImage!)
                      : null,
                  child: selectedImage == null
                      ? Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.grey.shade500,
                        )
                      : null,
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickProfileImage,
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'Update profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 20),

          // Email
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please Enter email';
              }
              return null;
            },
          ),

          const SizedBox(height: 18),

          // First Name
          TextFormField(
            controller: firstNameController,
            decoration: const InputDecoration(
              hintText: 'First Name',
            ),
          ),

          const SizedBox(height: 18),

          // Last Name
          TextFormField(
            controller: lastNameController,
            decoration: const InputDecoration(
              hintText: 'Last name',
            ),
          ),

          const SizedBox(height: 18),

          // Mobile
          TextFormField(
            controller: mobileController,
            decoration: const InputDecoration(
              hintText: 'Mobile',
            ),
          ),

          const SizedBox(height: 18),

          // Password
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),

          const SizedBox(height: 18),

          // Update button
          FilledButton(
            onPressed: updateProfile,
            child: const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 20,
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    ),
  ),
),
    );
  }
}
