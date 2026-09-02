import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutController extends GetxController {
  var appName = "Top News".obs;
  var description =
      "Latest breaking news and headlines at your fingertips, Categories : technology, business, sports, health, science , and entertainment. Bookmark import news for later reading.Search any news and share with friends"
          .obs;
  var developer = "Ahmad Sultan".obs;
  var version = "1.0.0".obs;
  var email = "ahmadsultaniswl@gmail.com".obs;

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email.value,
      queryParameters: {'subject': 'Support Request', 'body': 'HelloTeam,'},
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not launch email client',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Open Facebook
  Future<void> openFacebook() async {
    final Uri facebookUri = Uri.parse(
      'https://www.facebook.com/saieahmadsultan',
    );
    await launchUrl(facebookUri, mode: LaunchMode.externalApplication); // ✅
  }

  // Open LinkedIn
  Future<void> openLinkedIn() async {
    final Uri linkedInUri = Uri.parse(
      'https://www.linkedin.com/in/saieahmadsultan',
    );
    await launchUrl(linkedInUri, mode: LaunchMode.externalApplication); // ✅
  }
}
