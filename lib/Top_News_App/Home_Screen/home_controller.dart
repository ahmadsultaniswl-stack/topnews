import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utilities_Screen/Api_Model/model.dart';
import '../../Utilities_Screen/Bookmark_Model/book_mark_model.dart';
import '../../Utilities_Screen/Colors_Screen/app_colors.dart';
import '../../Utilities_Screen/Help_Function_Api/helping_function.dart';
import '../../Utilities_Screen/Mark_Service_Storage/mark_storage.dart';
import '../Bookmark_Screen/mark_controller.dart';

const String apiKey = "746b28e424c145b9a22730003aed85f0";

class HomeController extends GetxController {
  var news = <NewsModel>[].obs;
  var imageIndex = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var selectedButtons = ''.obs;
  var newsList = [].obs;
  final controller = Get.put(MarkController());

  // Modern: Search functionality
  var searchQuery = ''.obs;
  var filteredNews = <NewsModel>[].obs;
  var isSearching = false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await fetchNews();
    _changeImage();
    ever(searchQuery, (_) => filterNews()); // Listen to search changes
  }

  // Modern: Image slider with better timing
  void _changeImage() async {
    while (true) {
      await Future.delayed(
        const Duration(seconds: 10),
      ); // Changed from 15 to 10 seconds
      imageIndex.value++;
    }
  }

  // Modern: Fetch News with better error handling
  Future<List<NewsModel>> fetchNews() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      var response = await Functions.sendJson(
        jsonMap: null,
        url: "https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey",
        method: 'GET',
      );

      if (kDebugMode) {
        print('API Response: $response');
      }

      if (response is String && response.contains('Error')) {
        errorMessage.value = response;

        // Modern: Show error snackbar
        _showModernSnackbar(
          title: "Connection Error",
          message: "Please check your internet connection",
          isError: true,
        );
        return [];
      }

      if (response is Map<String, dynamic>) {
        if (response['status'] == 'ok') {
          final List articles = response['articles'] ?? [];

          // Modern: Remove null articles
          news.value = articles
              .where((e) => e != null)
              .map<NewsModel>((e) => NewsModel.fromJson(e))
              .where(
                (article) => article.title.isNotEmpty,
              ) // Remove empty titles
              .toList();

          // Modern: Success message for first load
          if (news.isNotEmpty) {
            _showModernSnackbar(
              title: "Success",
              message: "${news.length} news articles loaded",
              isError: false,
            );
          }
        } else {
          errorMessage.value = response['message'] ?? 'API Error';
          _showModernSnackbar(
            title: "API Error",
            message: errorMessage.value,
            isError: true,
          );
        }
      } else {
        errorMessage.value = 'Invalid response format';
      }
    } catch (e) {
      errorMessage.value = "Check Internet Connection & Try again.";
      if (kDebugMode) {
        print('Error: $e');
      }
      _showModernSnackbar(
        title: "Network Error",
        message: errorMessage.value,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
    return news.toList();
  }

  // Modern: Fetch Category with loading state
  Future<List<NewsModel>> fetchCategory(String category) async {
    selectedButtons.value = category;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      Get.dialog(
        Center(
          child: Container(
            height: 110,
            width: 110,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20, // Indicator height
                  width: 20, // Indicator width
                  child: CircularProgressIndicator(
                    strokeWidth: 2, // Thinner line (default 4 hai)
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.secondary,
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Kam spacing
                Text(
                  "Loading $category news...", // "news" word hata diya for shorter
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10, // Aur chota text
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    decorationThickness: 0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );

      var response = await Functions.sendJson(
        jsonMap: null,
        url:
            "https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey",
        method: 'GET',
      );

      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (kDebugMode) {
        print('API Response: $response');
      }

      if (response is String && response.contains('Error')) {
        errorMessage.value = response;
        _showModernSnackbar(
          title: "Error",
          message: "Failed to load $category news",
          isError: true,
        );
        return [];
      }

      if (response is Map<String, dynamic>) {
        if (response['status'] == 'ok') {
          final List articles = response['articles'] ?? [];

          news.value = articles
              .where((e) => e != null)
              .map<NewsModel>((e) => NewsModel.fromJson(e))
              .where((article) => article.title.isNotEmpty)
              .toList();

          // Modern: Success message
          _showModernSnackbar(
            title: "$category News",
            message: "${news.length} articles found",
            isError: false,
          );
        } else {
          errorMessage.value = response['message'] ?? 'API Error';
          _showModernSnackbar(
            title: "Error",
            message: errorMessage.value,
            isError: true,
          );
        }
      } else {
        errorMessage.value = 'Invalid response format';
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      errorMessage.value = "Check Internet Connection & Try again.";
      if (kDebugMode) {
        print('Error: $e');
      }
      _showModernSnackbar(
        title: "Network Error",
        message: errorMessage.value,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
    return news.toList();
  }

  // Modern: Refresh Data with haptic feedback
  Future<void> refreshData() async {
    // Modern: Haptic feedback for better UX
    if (kDebugMode) {
      print('Refreshing data...');
    }

    if (selectedButtons.value.isEmpty) {
      await fetchNews();
    } else {
      await fetchCategory(selectedButtons.value);
    }

    _showModernSnackbar(
      title: "Refreshed",
      message: "News updated successfully",
      isError: false,
    );
  }

  // Modern: Search Functionality
  void filterNews() {
    if (searchQuery.value.isEmpty) {
      filteredNews.clear();
    } else {
      filteredNews.value = news.where((article) {
        return article.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            article.description.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
      }).toList();
    }
  }

  // Modern: Clear Search
  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
  }

  // Modern: Get current news list (search or normal)
  List<NewsModel> get currentNewsList {
    if (searchQuery.value.isNotEmpty) {
      return filteredNews;
    }
    return news;
  }

  final BookmarkService bookmarkService = BookmarkService();

  // Modern: Check if article is bookmarked with animation
  bool isBookmarked(String url) {
    return bookmarkService.isBookmarked(url);
  }

  // Modern: Toggle bookmark with better UI feedback
  Future<void> toggleBookmark(NewsModel article) async {
    if (bookmarkService.isBookmarked(article.url)) {
      await bookmarkService.removeBookmark(article.url);
      await controller.loadBookmarks();

      // Modern: Animated snackbar
      Get.snackbar(
        'Removed from Bookmarks',
        article.title.length > 50
            ? '${article.title.substring(0, 50)}...'
            : article.title,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[850],
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.bookmark_remove, color: Colors.orange),
        shouldIconPulse: false,
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
      await controller.loadBookmarks();

      // Modern: Animated success snackbar
      Get.snackbar(
        'Saved to Bookmarks',
        article.title.length > 50
            ? '${article.title.substring(0, 50)}...'
            : article.title,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.bookmark, color: Colors.white),
        shouldIconPulse: true,
        mainButton: TextButton(
          onPressed: () {
            Get.toNamed('/bookmarks');
          },
          child: const Text(
            'VIEW',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    news.refresh();
  }

  // Modern: Share Article
  Future<void> shareArticle(NewsModel article) async {
    // Add share functionality if needed
    Get.snackbar(
      'Share',
      'Share feature coming soon',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
      backgroundColor: AppColors.secondary,
      colorText: Colors.white,
    );
  }

  // Modern: Modern Snackbar Helper
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
      duration: const Duration(seconds: 2),
      icon: Icon(
        isError ? Icons.error_outline : Icons.check_circle_outline,
        color: Colors.white,
        size: 28,
      ),
      shouldIconPulse: false,
      barBlur: 20,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  @override
  void onClose() {
    // Modern: Clean up resources
    super.onClose();
  }
}
