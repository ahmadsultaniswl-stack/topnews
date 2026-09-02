import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utilities_Screen/Bookmark_Model/book_mark_model.dart';
import '../../Utilities_Screen/Mark_Service_Storage/mark_storage.dart';

class MarkController extends GetxController {
  final BookmarkService bookmarkService = BookmarkService();
  var bookmarks = <BookmarkModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    isLoading.value = true;
    bookmarks.value = bookmarkService.getBookmarks();
    isLoading.value = false;
  }

  Future<void> addBookmark(BookmarkModel bookmark) async {
    await bookmarkService.addBookmark(bookmark);
    await loadBookmarks(); // Reload to update UI
    Get.snackbar(
      'Saved',
      'Bookmark added successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.bookmark_rounded, color: Colors.white),
    );
  }

  Future<void> removeBookmark(String url) async {
    await bookmarkService.removeBookmark(url);
    await loadBookmarks();
    Get.snackbar(
      'Removed',
      'Bookmark removed successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.delete_outline, color: Colors.white),
    );
  }

  Future<void> clearAllBookmarks() async {
    isLoading.value = true;
    await bookmarkService.clearAllBookmarks();
    await loadBookmarks();
    isLoading.value = false;
    Get.snackbar(
      'Cleared',
      'All bookmarks removed successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.delete_sweep, color: Colors.white),
    );
  }
}
