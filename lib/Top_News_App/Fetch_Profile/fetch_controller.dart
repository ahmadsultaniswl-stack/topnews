import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FetchController extends GetxController {
  String oldFirstName = "";
  String oldLastName = "";
  String oldEmail = "";
  var isLoading = false.obs;
  var displayName = "".obs;
  var displayEmail = "".obs;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Fetch Data
  void fetchUserData() async {
    try {
      isLoading.value = true;

      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (doc.exists) {
        var data = doc.data()!;

        oldFirstName = data['first name'] ?? '';
        oldLastName = data['last name'] ?? '';
        oldEmail = data['email'] ?? '';

        firstNameController.text = oldFirstName;
        lastNameController.text = oldLastName;
        emailController.text = oldEmail;
        // 👈 Yahan add karo (fetch hone ke baad card mein show karo)
        displayName.value = "$oldFirstName $oldLastName".trim();
        displayEmail.value = oldEmail;
      }
    } catch (e) {
      _showModernSnackbar(title: "Error", message: e.toString(), isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  // Update Data
  void updateUser() async {
    // Validation
    if (firstNameController.text.trim().isEmpty) {
      _showModernSnackbar(
        title: "Validation Error",
        message: "First name cannot be empty",
        isError: true,
      );
      return;
    }

    if (lastNameController.text.trim().isEmpty) {
      _showModernSnackbar(
        title: "Validation Error",
        message: "Last name cannot be empty",
        isError: true,
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      _showModernSnackbar(
        title: "Validation Error",
        message: "Email cannot be empty",
        isError: true,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      _showModernSnackbar(
        title: "Validation Error",
        message: "Please enter a valid email address",
        isError: true,
      );
      return;
    }

    // Check if any changes made
    if (firstNameController.text == oldFirstName &&
        lastNameController.text == oldLastName &&
        emailController.text == oldEmail) {
      _showModernSnackbar(
        title: "No Changes",
        message: "You haven't made any changes to update",
        isError: true,
      );
      return;
    }

    try {
      isLoading.value = true;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'first name': firstNameController.text.trim(),
        'last name': lastNameController.text.trim(),
        'email': emailController.text.trim(),
      });
      // ye change kiya hai email k liye
      if (emailController.text.trim() != oldEmail) {
        await FirebaseAuth.instance.currentUser!.verifyBeforeUpdateEmail(
          emailController.text.trim(),
        );
      }

      // Update old values
      oldFirstName = firstNameController.text.trim();
      oldLastName = lastNameController.text.trim();
      oldEmail = emailController.text.trim();
      // 👈 Yahan add karo (fetch hone ke baad card mein show karo)
      displayName.value = "$oldFirstName $oldLastName".trim();
      displayEmail.value = oldEmail;

      _showModernSnackbar(
        title: "Success!",
        message: "Your information has been updated successfully",
        isError: false,
      );
    } catch (e) {
      _showModernSnackbar(
        title: "Update Failed",
        message: e.toString(),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Modern Snackbar Helper
  void _showModernSnackbar({
    required String title,
    required String message,
    required bool isError,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade600,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
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
    );
  }

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
