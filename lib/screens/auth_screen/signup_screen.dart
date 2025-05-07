import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/dimensions.dart';



import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/password_textfield.dart';
import '../../widgets/snackbars.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  AuthController authController = Get.find<AuthController>();

  //controllers
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController refController = TextEditingController();

  bool termsAccepted = false;

  void registerUser() {
    final firstName = firstNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final email = mailController.text.trim();
    final number = phoneController.text.trim();
    final password = passController.text.trim();
    final confirmPassword = confirmPassController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        number.isEmpty ||
        password.isEmpty) {
      MySnackBars.failure(
          message: 'All fields except referral code are required',
          title: 'Error');
      return;
    }

    if (password != confirmPassword) {
      MySnackBars.failure(title: 'Error', message: 'Passwords do not match');
      return;
    }

    if (!termsAccepted) {
      MySnackBars.failure(
          title: 'Error',
          message: 'Please accept the terms and privacy policy');
      return;
    }

    authController.initiateSignUp(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: mailController.text.trim(),
        number: phoneController.text.trim(),
        password: confirmPassController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.height10 * 9),
              Text(
                'Sign Up As Admin',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                'Join to manage user actions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Enter First Name',
                controller: firstNameController,
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Enter Last Name',
                controller: lastNameController,
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Enter Email Address',
                controller: mailController,
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                hintText: 'Enter Whatsapp Number',
                controller: phoneController,
              ),
              SizedBox(height: Dimensions.height10),
              PasswordTextField(
                controller: passController,
              ),
              SizedBox(height: Dimensions.height10),
              PasswordTextField(
                controller: confirmPassController,
              ),

              SizedBox(height: Dimensions.height10),
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        setState(() {
                          termsAccepted = !termsAccepted;
                        });
                      },
                      child: Icon(
                          termsAccepted
                              ? Icons.check_box
                              : Icons.check_box_outline_blank_sharp,
                          color: Theme.of(context).dividerColor)),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    'I accept the terms and privacy Policy',
                    style: TextStyle(
                      fontSize: Dimensions.font14,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Obx(
                () => CustomButton(
                    text: authController.isLoading.value
                        ? 'Creating Admin...'
                        : 'Sign up Now',
                    onPressed: () {
                      authController.isLoading.value ? null : registerUser();
                    }),
              ),
              SizedBox(height: Dimensions.height10),
              InkWell(
                  onTap: () {
                    Get.toNamed(AppRoutes.signinScreen);
                  },
                  child: Text(
                    'Already an existing user?, Sign in now',
                    style: TextStyle(
                        fontSize: Dimensions.font15,
                        color: Theme.of(context).dividerColor,
                        fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
