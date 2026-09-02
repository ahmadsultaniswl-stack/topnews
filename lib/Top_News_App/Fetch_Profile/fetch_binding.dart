import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'fetch_controller.dart';

class FetchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchController(), fenix: true);
  }
}
