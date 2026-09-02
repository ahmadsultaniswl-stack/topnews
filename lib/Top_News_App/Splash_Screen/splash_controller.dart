import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../App_Routes/Routes_View.dart';

class SplashController extends GetxController {
  RxInt no = 1.obs;
  RxBool yes = true.obs;
  RxString version = "".obs;

  late PackageInfo versionDetails;

  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }

  void _loadVersion() async {
    versionDetails = await PackageInfo.fromPlatform();
    version.value = versionDetails.version; // Set version
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }
}
