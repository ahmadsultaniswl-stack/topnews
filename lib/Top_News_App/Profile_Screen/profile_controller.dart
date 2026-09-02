import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxBool isPasswordVisible = false.obs;
  var oldPassVisible = false.obs;
  var newPassVisible = false.obs;
  var confirmPassVisible = false.obs;

  // Additional variables for modern UI
  var isLoading = false.obs;
  var isDeleting = false.obs;
  var isLoggingOut = false.obs;

  // For animations or additional features
  var selectedOption = "".obs;

  // Original methods
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleOldPass() {
    oldPassVisible.value = !oldPassVisible.value;
  }

  void toggleNewPass() {
    newPassVisible.value = !newPassVisible.value;
  }

  void toggleConfirmPass() {
    confirmPassVisible.value = !confirmPassVisible.value;
  }

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setDeleting(bool value) {
    isDeleting.value = value;
  }

  void setLoggingOut(bool value) {
    isLoggingOut.value = value;
  }

  void setSelectedOption(String option) {
    selectedOption.value = option;
  }

  // Clear all controllers or reset state if needed
  void resetState() {
    isLoading.value = false;
    isDeleting.value = false;
    isLoggingOut.value = false;
    selectedOption.value = "";
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}
