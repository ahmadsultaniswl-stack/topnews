import 'package:get/get.dart';
import 'package:top_news/Top_News_App/Signup_Screen/signup_cont.dart';

class SignupBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignupController());
  }
}
