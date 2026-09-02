import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:top_news/Top_News_App/Signup_Screen/signup_cont.dart';

import '../../Utilities_Screen/Auth_Services/auth_services.dart';
import '../../Utilities_Screen/Colors_Screen/app_colors.dart';
import '../Login_Screen/login_view.dart';

class SignupView extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());
  final AuthService con = Get.put(AuthService());
  SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: _buildModernAppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Obx(
              () => AnimatedOpacity(
                duration: const Duration(milliseconds: 600),
                opacity: controller.animationValue.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Text
                    _buildWelcomeText(),

                    const SizedBox(height: 30),

                    // First Name Field
                    _buildModernTextField(
                      label: 'First Name',
                      hintText: 'Enter your first name',
                      errorText: controller.firstNameError.value,
                      onChanged: (value) => controller.firstName.value = value,
                      prefixIcon: Icons.person_2_outlined,
                      isFocused: controller.isFirstNameFocused,
                    ),

                    const SizedBox(height: 18),

                    // Last Name Field
                    _buildModernTextField(
                      label: 'Last Name',
                      hintText: 'Enter your last name',
                      errorText: controller.lastNameError.value,
                      onChanged: (value) => controller.lastName.value = value,
                      prefixIcon: Icons.person_outline,
                      isFocused: controller.isLastNameFocused,
                    ),

                    const SizedBox(height: 18),

                    // Email Field
                    _buildModernTextField(
                      label: 'Email Address',
                      hintText: 'Enter your email',
                      errorText: controller.emailError.value,
                      onChanged: (value) => controller.email.value = value,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      isFocused: controller.isEmailFocused,
                    ),

                    const SizedBox(height: 18),

                    // Password Field
                    _buildModernPasswordField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      errorText: controller.passwordError.value,
                      onChanged: (value) => controller.password.value = value,
                      isVisible: controller.isPasswordVisible,
                      onToggle: controller.togglePasswordVisibility,
                      isFocused: controller.isPasswordFocused,
                    ),

                    const SizedBox(height: 18),

                    // Confirm Password Field
                    _buildModernPasswordField(
                      label: 'Confirm Password',
                      hintText: 'Confirm your password',
                      errorText: controller.confirmPasswordError.value,
                      onChanged: (value) =>
                          controller.confirmPassword.value = value,
                      isVisible: controller.isConfirmPasswordVisible,
                      onToggle: controller.toggleConfirmPasswordVisibility,
                      isFocused: controller.isConfirmPasswordFocused,
                    ),

                    const SizedBox(height: 28),

                    // Register Button
                    _buildModernRegisterButton(),

                    const SizedBox(height: 16),

                    // Login Link
                    _buildLoginLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Modern App Bar
  PreferredSizeWidget _buildModernAppBar() {
    return AppBar(
      title: const Text(
        'Create Account',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
    );
  }

  // Welcome Text
  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Join Us Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Create your account to get started',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Modern Text Field
  Widget _buildModernTextField({
    required String label,
    required String hintText,
    required String errorText,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
    required RxBool isFocused,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey.shade300,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText.isNotEmpty
                  ? Colors.red.shade400
                  : Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            cursorColor: AppColors.secondary,
            onTap: () {
              // Clear error when tapped
              if (label == 'First Name') controller.firstNameError.value = '';
              if (label == 'Last Name') controller.lastNameError.value = '';
              if (label == 'Email Address') controller.emailError.value = '';
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade600),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.secondary, size: 22)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.secondary, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: Colors.red.shade400),
                const SizedBox(width: 6),
                Text(
                  errorText,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Modern Password Field
  Widget _buildModernPasswordField({
    required String label,
    required String hintText,
    required String errorText,
    required Function(String) onChanged,
    required RxBool isVisible,
    required VoidCallback onToggle,
    required RxBool isFocused,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.grey.shade300,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorText.isNotEmpty
                  ? Colors.red.shade400
                  : Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Obx(
            () => TextField(
              onChanged: onChanged,
              obscureText: !isVisible.value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              cursorColor: AppColors.secondary,
              onTap: () {
                if (label == 'Password') {
                  controller.passwordError.value = '';
                } else {
                  controller.confirmPasswordError.value = '';
                }
              },
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade600),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.secondary,
                  size: 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isVisible.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  onPressed: onToggle,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.secondary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: Colors.red.shade400),
                const SizedBox(width: 6),
                Text(
                  errorText,
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Modern Register Button
  Widget _buildModernRegisterButton() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () => controller.register(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: controller.isLoading.value
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
        ),
      ),
    );
  }

  // Login Link
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        ),
        TextButton(
          onPressed: () {
            Get.offAll(() => LoginView());
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Login',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
