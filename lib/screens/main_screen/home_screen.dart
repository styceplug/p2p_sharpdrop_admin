import 'package:admin_p2p_sharpdrop/models/user_model.dart';
import 'package:admin_p2p_sharpdrop/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_p2p_sharpdrop/controllers/chat_controller.dart';
import 'package:admin_p2p_sharpdrop/models/channel_chat_model.dart';
import 'package:admin_p2p_sharpdrop/widgets/custom_button.dart';

import 'package:shimmer/shimmer.dart';

import '../../controllers/theme_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colotToHex.dart';
import '../../utils/dimensions.dart';
import '../../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeController themeController = Get.find<ThemeController>();
  UserController userController = Get.find<UserController>();
  ChatController chatController = Get.find<ChatController>();

  void showCreateChannelDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    final List<Color> availableColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
      Colors.yellow,
      Colors.brown,
      Colors.indigo,
      Colors.lime,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
    ];

    Rx<Color> selectedColor = availableColors.first.obs;

    Get.dialog(
      AlertDialog(
        title: Text('Create Channel'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Channel Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Obx(() => DropdownButtonFormField<Color>(
                    value: selectedColor.value,
                    decoration: InputDecoration(
                      labelText: 'Select Color',
                      border: OutlineInputBorder(),
                    ),
                    items: availableColors.map((color) {
                      return DropdownMenuItem<Color>(
                        value: color,
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(colorString(color)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (color) {
                      if (color != null) {
                        selectedColor.value = color;
                      }
                    },
                  )),
              SizedBox(height: 20),
              Obx(() {
                return CategoryCard(
                  title: nameController.text.isEmpty
                      ? 'Channel Preview'
                      : nameController.text,
                  color: selectedColor.value,
                  onTap: () {},
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog on cancel
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final hexColor = colorToHex(selectedColor.value);
                userController.isLoading.value = true;
                await userController.createChannel(name: name, color: hexColor);
              }
              userController.isLoading.value = false;
            },
            child: Obx(() {
              if (userController.isLoading.value) {
                return CircularProgressIndicator(
                  color: Theme.of(context).unselectedWidgetColor,
                );
              } else {
                return Text('Create');
              }
            }),
          )
        ],
      ),
    );
  }

  Future<void> closeDialog() async {
    await Future.delayed(
        Duration(milliseconds: 500)); // Delay to ensure success handling
    Get.back(); // Close the dialog
  }

  @override
  void initState() {
    userController.getChannels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Hi, Administrator',
          style: TextStyle(
            color: Theme.of(context).dividerColor,
            fontSize: Dimensions.font17,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
        leadingWidth: Dimensions.width10 * 5.5,
        leading: Container(
          margin: EdgeInsets.only(left: Dimensions.width20),
          height: Dimensions.height30,
          width: Dimensions.width30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppConstants.getPngAsset('avatar')),
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  themeController.toggleTheme();
                },
                child: Icon(
                  Icons.light_mode_outlined,
                  color: Theme.of(context).dividerColor,
                  size: Dimensions.iconSize24,
                ),
              ),
              SizedBox(width: Dimensions.width10),
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.notificationScreen);
                },
                child: Icon(
                  CupertinoIcons.bell,
                  color: Theme.of(context).dividerColor,
                  size: Dimensions.iconSize24,
                ),
              ),
              SizedBox(width: Dimensions.width20),
            ],
          )
        ],
      ),
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20, vertical: Dimensions.height20),
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {},
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomButton(
                  // isDisabled: userModel.value?.role != 'superAdmin',
                  text: 'Create New Channel',
                  onPressed: () {
                    print(userController.userDetail.value?.role);
                    print('role detected');
                    if (userController.userDetail.value?.role != 'superAdmin') {
                      MySnackBars.failure(
                          title: 'Sorry',
                          message:
                              "Only Super Admins can create channels, Contact your Super Admin");
                    } else {
                      showCreateChannelDialog(context);
                    }
                  },
                ),
                SizedBox(height: Dimensions.height20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Existing Channels',
                      style: TextStyle(
                        fontSize: Dimensions.font18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Container(
                  child: Obx(() {
                    if (userController.channels.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          SizedBox(height: Dimensions.height100 * 2.5),
                          Text('No Existing Channel Available'),
                        ],
                      ));
                    }
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userController.channels.length,
                          itemBuilder: (context, index) {
                            final channel = userController.channels[index];
                            return CategoryCard(
                              title: channel.name,
                              color: Color(int.parse(
                                  channel.color.replaceAll('#', '0xff'))),
                              onTap: () async {
                                await chatController.getChannelChat(channel.id);
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: Dimensions.height50,
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
