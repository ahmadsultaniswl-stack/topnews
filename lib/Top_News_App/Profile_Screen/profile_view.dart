import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:top_news/Top_News_App/About_Us/about_view.dart';
import 'package:top_news/Top_News_App/Fetch_Profile/fetch_profile.dart';
import 'package:top_news/Top_News_App/Profile_Screen/profile_controller.dart';
import 'package:top_news/Utilities_Screen/Auth_Services/auth_services.dart';
import 'package:top_news/Utilities_Screen/Colors_Screen/app_colors.dart';
import 'package:top_news/Utilities_Screen/Theme_Controller/theme_controller.dart';

import '../App_Routes/Routes_View.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});
  final controller = Get.put(ProfileController());
  final passwordController = TextEditingController();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        //toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Profile Header Card
            _buildModernCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "My Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "View and edit your profile information",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                            onPressed: () => Get.to(() => FetchView()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () => Get.to(() => FetchView()),
            ),

            const SizedBox(height: 20),

            // Appearance Section
            _buildSectionHeader("Appearance"),
            const SizedBox(height: 12),

            _buildModernCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.dark_mode,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dark Mode",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Switch between light and dark theme",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: themeController.isDarkMode.value,
                      onChanged: (val) => themeController.toggleTheme(),
                      activeColor: Colors.black,
                      inactiveThumbColor: AppColors.primary,
                      activeTrackColor: Colors.grey[850],
                      inactiveTrackColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Section
            _buildSectionHeader("Account"),
            const SizedBox(height: 12),

            _buildModernCard(
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.lock_outline_rounded,
                    title: "Change Password",
                    subtitle: "Update your account password",
                    onTap: () => _showChangePasswordDialog(context),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.logout_rounded,
                    title: "Logout",
                    subtitle: "Sign out from your account",
                    iconColor: Colors.orangeAccent,
                    textColor: Colors.orangeAccent,
                    onTap: () => _logout(),
                  ),
                  _buildDivider(),
                  _buildSettingTile(
                    icon: Icons.delete_outline_rounded,
                    title: "Delete Account",
                    subtitle: "Permanently remove your account",
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    onTap: () => _showDeleteAccountDialog(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // About Section
            _buildSectionHeader("More"),
            const SizedBox(height: 12),

            _buildModernCard(
              child: _buildSettingTile(
                icon: Icons.info_outline_rounded,
                title: "About Us",
                subtitle: "Learn more about Top News",
                onTap: () => Get.to(() => AboutView()),
                showArrow: true,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildModernCard({required Widget child, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
    bool showArrow = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
      ),
      trailing: showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 14,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.white.withOpacity(0.1),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final oldPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        insetPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ), // ✅ Add this
        child: SingleChildScrollView(
          // ✅ Add SingleChildScrollView
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20, // ✅ 22 se 20 kar do
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 6), // ✅ 8 se 6
                Center(
                  child: Text(
                    "Create a new secure password",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // ✅ 24 se 20

                _buildPasswordField(
                  controller: oldPassController,
                  hint: "Current Password",
                  visible: controller.oldPassVisible,
                  onToggle: controller.toggleOldPass,
                ),
                const SizedBox(height: 12), // ✅ 16 se 12

                _buildPasswordField(
                  controller: newPassController,
                  hint: "New Password",
                  visible: controller.newPassVisible,
                  onToggle: controller.toggleNewPass,
                ),
                const SizedBox(height: 12), // ✅ 16 se 12

                _buildPasswordField(
                  controller: confirmPassController,
                  hint: "Confirm Password",
                  visible: controller.confirmPassVisible,
                  onToggle: controller.toggleConfirmPass,
                ),
                const SizedBox(height: 20), // ✅ 24 se 20

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ), // ✅ 12 se 10
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // ✅ 16 se 12
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          String oldPass = oldPassController.text.trim();
                          String newPass = newPassController.text.trim();
                          String confirmPass = confirmPassController.text
                              .trim();

                          if (oldPass.isEmpty ||
                              newPass.isEmpty ||
                              confirmPass.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "All fields required",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          if (newPass != confirmPass) {
                            Get.snackbar(
                              "Error",
                              "Passwords do not match",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          try {
                            await AuthService().changePassword(
                              oldPass,
                              newPass,
                            );
                            Get.back();
                            Get.snackbar(
                              "Success",
                              "Password changed successfully",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                            Get.toNamed(AppRoutes.login);
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              e.toString(),
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ), // ✅ 12 se 10
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // ✅ 16 se 12
                          ),
                        ),
                        child: const Text(
                          "Change",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required RxBool visible, // ✅ RxBool
    required VoidCallback onToggle,
  }) {
    return Obx(
      // ✅ Obx wrapper
      () => TextField(
        controller: controller,
        obscureText: !visible.value, // ✅ .value
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.white.withOpacity(0.7),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              visible.value
                  ? Icons.visibility
                  : Icons.visibility_off, // ✅ .value
              color: Colors.white.withOpacity(0.7),
            ),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    final passwordFieldController = TextEditingController();
    final RxBool isPasswordVisible = false.obs;

    Get.dialog(
      Dialog(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "This action is permanent and cannot be undone. All your data will be lost.",
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
              ),
              const SizedBox(height: 24),
              Obx(
                () => TextField(
                  controller: passwordFieldController,
                  obscureText: !isPasswordVisible.value, // 👈 Toggle
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your password to confirm",
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    suffixIcon: IconButton(
                      // 👈 Yeh add karo
                      onPressed: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                      icon: Icon(
                        isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        String password = passwordFieldController.text.trim();
                        if (password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter password",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        try {
                          await AuthService().deleteAccount(password);
                          Get.back();
                          Get.snackbar(
                            "Success",
                            "Account deleted successfully",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          Get.toNamed(AppRoutes.signup);
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            e.toString(),
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text("Delete"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() async {
    Get.back();
    await AuthService().signOut();
    Get.snackbar(
      "Success",
      "Logged out successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.toNamed(AppRoutes.login);
  }
}
