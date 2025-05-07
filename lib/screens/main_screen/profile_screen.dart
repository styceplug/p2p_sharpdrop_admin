import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/controllers/user_controller.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/routes.dart';
import '../../utils/dimensions.dart';

import 'package:shimmer/shimmer.dart';

import '../../utils/app_constants.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

AuthController authController = Get.find<AuthController>();
UserController userController = Get.find<UserController>();


class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Image
                Obx(() {
                  final user = userController.userDetail.value;

                  if (user == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                      ),
                    );
                  }

                  return CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage(AppConstants.getPngAsset('avatar')),
                  );
                }),

                SizedBox(height: 20),

                // User Name
                Obx(() {
                  final user = userController.userDetail.value;

                  if (user == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 200,
                        height: 20,
                        color: Colors.white,
                      ),
                    );
                  }

                  return Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                }),

                SizedBox(height: 10),

                // User Email
                Obx(() {
                  final user = userController.userDetail.value;

                  if (user == null) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 200,
                        height: 20,
                        color: Colors.white,
                      ),
                    );
                  }

                  return Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).dividerColor,
                    ),
                  );
                }),

                SizedBox(height: Dimensions.height30),

                // Log Out Button
                InkWell(
                  onTap: () {
                    authController.logOut();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'LOG OUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: Dimensions.height30),

                /*Container(
                  height: Dimensions.height10 * 9,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                          color: Theme.of(context).dividerColor,
                          width: Dimensions.width10 / Dimensions.width30),
                      borderRadius: BorderRadius.circular(Dimensions.radius15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // SizedBox(width: Dimensions.width10,),
                      Icon(Icons.support_agent,
                          color: Theme.of(context).dividerColor),
                      Text(
                        'Help and Support',
                        style: TextStyle(
                            fontSize: Dimensions.font20,
                            color: Theme.of(context).dividerColor),
                      ),
                      SizedBox(width: Dimensions.width113),

                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                InkWell(
                  onTap: (){Get.toNamed(AppRoutes.referralScreen);},
                  child: Container(
                    height: Dimensions.height10 * 9,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: Dimensions.width10 / Dimensions.width30),
                        borderRadius: BorderRadius.circular(Dimensions.radius15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // SizedBox(width: Dimensions.width10,),
                        Icon(Icons.remove_from_queue,
                            color: Theme.of(context).dividerColor),
                        Text(
                          'Referral Program',
                          style: TextStyle(
                              fontSize: Dimensions.font20,
                              color: Theme.of(context).dividerColor),
                        ),
                        SizedBox(width: Dimensions.width113),

                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
