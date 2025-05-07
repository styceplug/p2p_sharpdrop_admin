import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/screens/main_screen/profile_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthController authController = Get.find<AuthController>();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAppLaunchFlow();
    });
  }

  Future<void> checkAppLaunchFlow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


    bool isFirstTime = prefs.getBool('is_first_time') ?? true;

    await authController.loadToken();
    await userController.getUserDetails();
    await userController.getChannels();

    await Future.delayed(const Duration(seconds: 2)); // splash delay

    if (isFirstTime) {
      await prefs.setBool('is_first_time', false);
      Get.offAllNamed(AppRoutes.bottomNav);
    } else if (authController.authToken.value.isNotEmpty) {
      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      Get.offAllNamed(AppRoutes.signinScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Center(
          child: Container(
            height: Dimensions.height100,
            width: Dimensions.width100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              image: DecorationImage(
                image: AssetImage(AppConstants.getPngAsset('logo')),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
