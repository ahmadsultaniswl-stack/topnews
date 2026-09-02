import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utilities_Screen/Auth_Services/auth_services.dart';
import '../../Utilities_Screen/Colors_Screen/app_colors.dart';
import '../../Utilities_Screen/Constants/constants.dart';
import '../../Utilities_Screen/SqLite_Database/sqlite_database.dart';
import '../App_Routes/Routes_View.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;
  final RxBool isPasswordVisible = false.obs;

  // Modern: Additional UI states
  final RxDouble animationValue = 0.0.obs;
  final RxBool isGoogleLoading = false.obs;
  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;

  void clearForm() {
    emailController.text = '';
    passwordController.text = '';
    clearErrors();
  }

  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }

  bool validateEmail() {
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      return false;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(emailController.text)) {
      emailError.value = 'Please enter a valid email address';
      return false;
    }

    emailError.value = '';
    return true;
  }

  bool validatePassword() {
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      return false;
    }

    if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      return false;
    }

    passwordError.value = '';
    return true;
  }

  bool validateForm() {
    final isEmailValid = validateEmail();
    final isPasswordValid = validatePassword();
    return isEmailValid && isPasswordValid;
  }

  // Modern: Enhanced credential loading with animation
  void loadSavedCredentials() async {
    try {
      final db = await SQLite.instance.database;
      final queryData = await db.rawQuery(
        "SELECT Email, Password FROM User WHERE UserID = 1",
      );

      if (queryData.isNotEmpty && queryData[0]["Email"] != null) {
        emailController.text = queryData[0]["Email"].toString();
        passwordController.text = queryData[0]["Password"].toString();

        if (emailController.text.isNotEmpty) {
          rememberMe.value = true;
          Constants.email = emailController.text;
          Constants.name = 'Ali Sultan';
          _showModernSnackbar(
            title: "Welcome Back!",
            message: "Auto-filled your credentials",
            isError: false,
            duration: 2,
          );
        } else {
          rememberMe.value = false;
        }
      }
    } catch (e) {
      print('Error loading credentials: $e');
    }
  }

  String appToken = "";

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
    loadSavedCredentials();
    _initializeFirebase();
  }

  // Modern: Start entrance animation
  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      animationValue.value = 1.0;
    });
  }

  // Modern: Firebase initialization with better error handling
  void _initializeFirebase() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        appToken = token;
        Constants.token = token;
        print("FCM Token initialized successfully");
      }
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  // Modern: Enhanced login with better feedback
  Future<void> login() async {
    if (!validateForm()) {
      _showModernSnackbar(
        title: "Validation Error",
        message: "Please check your email and password",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      User? user = await _authService.loginWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        _showModernSnackbar(
          title: "Welcome Back! ",
          message: "Successfully logged in",
          isError: false,
          duration: 2,
        );

        await _saveCredentialsToDatabase();

        Constants.email = emailController.text;
        Constants.name = 'Ali Sultan';

        // Modern: Delay navigation for smooth animation
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.bottom);
      }
    } catch (e) {
      String message;
      if (e is FirebaseAuthException) {
        message = _authService.handleAuthException(e);
      } else {
        message = e.toString();
      }

      _showModernSnackbar(
        title: "Login Failed ",
        message: message,
        isError: true,
        duration: 3,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Modern: Save credentials with better logic
  Future<void> _saveCredentialsToDatabase() async {
    final db = await SQLite.instance.database;
    if (rememberMe.value) {
      await db.rawUpdate("""
        UPDATE User SET
        Email = '${emailController.text.trim()}',
        Password = '${passwordController.text.trim()}'
        WHERE UserID = 1
      """);
    } else {
      await db.rawUpdate("""
        UPDATE User SET
        Email = '',
        Password = ''
        WHERE UserID = 1
      """);
    }
  }

  // Modern: Enhanced forgot password with better UX
  Future<void> forgotPassword() async {
    if (!validateEmail()) {
      _showModernSnackbar(
        title: "Invalid Email",
        message: "Please enter a valid email address",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    try {
      bool exists = await _authService.checkEmailExists(emailController.text);

      if (!exists) {
        _showModernSnackbar(
          title: "Email Not Found",
          message: "No account found with this email address",
          isError: true,
        );
        return;
      }

      await _authService.sendPasswordResetEmail(emailController.text);

      _showModernSnackbar(
        title: "Reset Link Sent!",
        message: "Check your email for password reset instructions",
        isError: false,
        duration: 3,
      );
    } catch (e) {
      _showModernSnackbar(title: "Error", message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  bool get isFormValid {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  // Modern: Enhanced Google login with better loading state
  Future<void> googleLogin() async {
    try {
      isGoogleLoading.value = true;

      User? user = await _authService.signInWithGoogle();

      if (user != null) {
        _showModernSnackbar(
          title: "Google Login Success! 🌐",
          message: "Welcome to Top News",
          isError: false,
          duration: 2,
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(AppRoutes.bottom);
      }
    } catch (e) {
      _showModernSnackbar(
        title: "Google Login Failed",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isGoogleLoading.value = false;
    }
  }

  // Modern: Modern snackbar helper
  void _showModernSnackbar({
    required String title,
    required String message,
    required bool isError,
    int duration = 2,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red.shade700 : AppColors.secondary,
      colorText: Colors.white,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      duration: Duration(seconds: duration),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
        size: 28,
      ),
      shouldIconPulse: false,
      barBlur: 20,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
