import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Bookmark_Screen/mark_view.dart';
import '../Explore_Screen/explore_view.dart';
import '../Home_Screen/home_view.dart';
import '../Profile_Screen/profile_view.dart';

class BottomController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var selectedIndex = 0.obs;
  var showBottomBar = true.obs;

  List<Widget> get pages => [
    HomeView(),
    ExploreView(),
    MarkView(),
    ProfileView(),
  ];

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
