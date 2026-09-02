import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:top_news/Utilities_Screen/Api_Model/model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utilities_Screen/Bookmark_Model/book_mark_model.dart';
import '../../Utilities_Screen/Mark_Service_Storage/mark_storage.dart';

class ArticleController extends GetxController {
  final BookmarkService bookmarkService = BookmarkService();
  var bookmarkVersion = 0.obs;
  var isSharing = false.obs;

  bool isBookmarked(String url) {
    return bookmarkService.isBookmarked(url);
  }

  Future<void> toggleBookmark(NewsModel article) async {
    try {
      if (bookmarkService.isBookmarked(article.url)) {
        await bookmarkService.removeBookmark(article.url);
        _showModernSnackbar(
          title: "Removed",
          message: "Article removed from bookmarks",
          isError: false,
          icon: Icons.bookmark_remove,
        );
      } else {
        final bookmark = BookmarkModel(
          title: article.title,
          description: article.description,
          image: article.image,
          content: article.content,
          source: article.source,
          url: article.url,
          savedAt: DateTime.now(),
        );
        await bookmarkService.addBookmark(bookmark);
        _showModernSnackbar(
          title: "Saved",
          message: "Article saved to bookmarks",
          isError: false,
          icon: Icons.bookmark,
        );
      }
      bookmarkVersion.value++;
      update();
    } catch (e) {
      _showModernSnackbar(
        title: "Error",
        message: "Something went wrong",
        isError: true,
        icon: Icons.error_outline,
      );
    }
  }

  Future<void> shareArticle(String url) async {
    try {
      isSharing.value = true;
      await Share.share(
        '📰 Check out this news article!\n\n$url\n\nShared via News App',
      );
    } catch (e) {
      _showModernSnackbar(
        title: "Error",
        message: "Could not share article",
        isError: true,
        icon: Icons.share,
      );
    } finally {
      isSharing.value = false;
    }
  }

  Future<void> openInBrowser(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showModernSnackbar(
          title: "Error",
          message: "Could not open in browser",
          isError: true,
          icon: Icons.open_in_browser,
        );
      }
    } catch (e) {
      _showModernSnackbar(
        title: "Error",
        message: "Invalid URL",
        isError: true,
        icon: Icons.error_outline,
      );
    }
  }

  void _showModernSnackbar({
    required String title,
    required String message,
    required bool isError,
    required IconData icon,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade600,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
      icon: Icon(icon, color: Colors.white, size: 24),
      shouldIconPulse: false,
      barBlur: 20,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
