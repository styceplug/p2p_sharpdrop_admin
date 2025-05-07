import 'package:get/get.dart';



import '../screens/auth_screen/signin_screen.dart';
import '../screens/auth_screen/signup_screen.dart';
import '../screens/main_screen/chat_room.dart';
import '../screens/messaging_screen.dart';

import '../screens/splash_onboard/onboarding_screen.dart';
import '../screens/splash_onboard/splash_screen.dart';
import '../widgets/bottom_nav.dart';

class AppRoutes {
  static const String splashScreen = '/splash-screen';
  static const String onboardingScreen = '/onboarding-screen';
  static const String signupScreen = '/signup-screen';
  static const String signinScreen = '/signin-screen';
  static const String bottomNav = '/bottom-nav';
  static const String messagingScreen = '/messaging-screen';
  static const String referralScreen = '/referral-screen';
  static const String referralList = '/referral-list';
  static const String chatRoom = '/chat-room';




  static final routes = [
    GetPage(
      name: splashScreen,
      page: () {
        return const SplashScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardingScreen,
      page: () {
        return const OnBoardingScreen();
      },
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: signupScreen,
      page: () {
        return const SignupScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: signinScreen,
      page: () {
        return const SigninScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomNav,
      page: () {
        return const BottomNav();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: messagingScreen,
      page: () => MessagingScreen(

      ),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: chatRoom,
      page: () {
        return const ChatRoom();
      },
      transition: Transition.fadeIn,
    ),


  ];
}
