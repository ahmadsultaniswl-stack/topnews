import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../Utilities_Screen/Colors_Screen/app_colors.dart';
import 'Bottom_Controller.dart';

class BottomView extends StatelessWidget {
  BottomView({super.key});

  final BottomController controller = Get.put(BottomController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            controller.showBottomBar.value = false;
          } else if (notification.direction == ScrollDirection.forward) {
            controller.showBottomBar.value = true;
          }
          return true;
        },

        child: Obx(() => controller.pages[controller.selectedIndex.value]),
      ),
      bottomNavigationBar: Obx(
        () => controller.showBottomBar.value
            ? Container(
                height: 56,
                decoration: BoxDecoration(),
                child: BottomNavigationBar(
                  currentIndex: controller.selectedIndex.value,
                  onTap: controller.changeIndex,
                  backgroundColor: AppColors.primary,
                  selectedItemColor: AppColors.secondary,
                  unselectedItemColor: AppColors.tertiary,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: TextStyle(fontSize: 13),
                  unselectedLabelStyle: TextStyle(fontSize: 9),
                  selectedIconTheme: IconThemeData(size: 23),
                  unselectedIconTheme: IconThemeData(size: 19),
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.explore),
                      label: "Explore",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark),
                      label: "Bookmark",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Profile",
                    ),
                  ],
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
