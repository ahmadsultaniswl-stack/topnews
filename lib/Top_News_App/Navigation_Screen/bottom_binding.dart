import 'package:get/get.dart';

import 'Bottom_Controller.dart';

class BottomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomController());
  }
}
