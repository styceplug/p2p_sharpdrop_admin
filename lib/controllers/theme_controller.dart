import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;



  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(theme);
  }
}

