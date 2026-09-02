import 'package:get/get.dart';
import 'package:top_news/Top_News_App/Home_Screen/home_controller.dart';

class MarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
