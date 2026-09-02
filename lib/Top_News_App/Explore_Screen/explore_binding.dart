import 'package:get/get.dart';

import 'explore_controller.dart';

class ExploreBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ SAHI - Controller register karo, Binding nahi
    Get.lazyPut<ExploreController>(() => ExploreController());
  }
}
