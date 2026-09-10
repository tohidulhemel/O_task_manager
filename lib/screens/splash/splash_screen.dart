import 'package:task_manager/controllers/auth_controller.dart';
import 'package:task_manager/screens/auth/login_screen.dart';
import 'package:task_manager/screens/navigation/main_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/asset_path.dart';
import '../../widgets/common/screen_bg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    moveToNextScreen();
  }

  Future moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    await AuthController.getUserData();
    bool isLogin = await AuthController.isUserLogin();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLogin ? MainNavScreen() : LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: Center(
          child: SvgPicture.asset(AssetPath.logo, width: 300, height: 300),
        ),
      ),
    );
  }
}
