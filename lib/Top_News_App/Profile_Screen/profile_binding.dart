import 'package:get/get.dart';
import 'package:top_news/Top_News_App/Profile_Screen/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
