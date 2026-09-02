import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../Utilities_Screen/Api_Model/model.dart';

class ExploreController extends GetxController {
  final String apiKey = "746b28e424c145b9a22730003aed85f0";

  final ScrollController scrollController = ScrollController();

  final TextEditingController searchTextController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxList<NewsModel> exploreNews = <NewsModel>[].obs;
  final RxString selectedCategory = "technology".obs;
  final RxString searchQuery = "".obs;

  final List<String> categories = [
    "technology",
    "business",
    "sports",
    "health",
    "science",
    "entertainment",
  ];

  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  final RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_scrollListener);
    fetchExploreNews();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreNews();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  Future<void> fetchExploreNews({
    String? category,
    bool isRefresh = false,
    String? query,
  }) async {
    try {
      if (isRefresh || category != null || query != null) {
        currentPage.value = 1;
        hasMoreData.value = true;
        exploreNews.clear();
      }

      if (category != null) {
        selectedCategory.value = category;
      }

      if (query != null) {
        searchQuery.value = query;
      }

      if (!isLoadingMore.value) {
        isLoading.value = true;
      }

      String url;

      if (searchQuery.value.isNotEmpty) {
        url =
            "https://newsapi.org/v2/everything?q=${searchQuery.value}&page=${currentPage.value}&pageSize=20&apiKey=$apiKey";
      } else {
        url =
            "https://newsapi.org/v2/top-headlines?country=us&category=${selectedCategory.value}&page=${currentPage.value}&pageSize=20&apiKey=$apiKey";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final articles = data['articles'] as List;

        final newNews = articles
            .where(
              (e) =>
                  e['title'] != null &&
                  e['title'] != '[Removed]' &&
                  e['description'] != null,
            )
            .map((e) => NewsModel.fromJson(e))
            .toList();

        exploreNews.addAll(newNews);
        hasMoreData.value = newNews.length >= 20;
      } else {
        Get.snackbar(
          "Error",
          "News load nahi ho saki. Status: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xff1E293B),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Kuch masla aaya: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff1E293B),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreNews() async {
    if (!hasMoreData.value || isLoadingMore.value || isLoading.value) return;
    isLoadingMore.value = true;
    currentPage.value++;
    await fetchExploreNews();
  }

  Future<void> refreshNews() async {
    searchQuery.value = "";
    searchTextController.clear();
    await fetchExploreNews(isRefresh: true);
  }

  void searchNews(String query) {
    if (query.trim().isEmpty) return;
    searchQuery.value = query.trim();
    fetchExploreNews(query: query.trim());
  }

  void clearSearch() {
    searchQuery.value = "";
    searchTextController.clear();
    fetchExploreNews(isRefresh: true);
  }
}
