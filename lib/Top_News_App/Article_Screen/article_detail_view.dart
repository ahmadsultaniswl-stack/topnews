import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utilities_Screen/Api_Model/model.dart';
import '../../Utilities_Screen/Colors_Screen/app_colors.dart';
import 'article_controller.dart';

class ArticleDetailView extends StatelessWidget {
  final NewsModel article;

  const ArticleDetailView({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ArticleController());

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: _buildModernAppBar(controller),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            _buildHeroImage(),

            // Content Section
            _buildContentSection(controller),

            // Action Buttons
            //_buildActionButtons(controller),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Modern AppBar
  PreferredSizeWidget _buildModernAppBar(ArticleController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        'News Details',
        style: TextStyle(
          color: AppColors.secondary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      actions: [
        Obx(() {
          controller.bookmarkVersion.value;
          return _buildActionIcon(
            icon: controller.isBookmarked(article.url)
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: controller.isBookmarked(article.url)
                ? AppColors.secondary
                : Colors.white,
            onPressed: () => controller.toggleBookmark(article),
          );
        }),
        _buildActionIcon(
          icon: Icons.share_outlined,
          color: Colors.white,
          onPressed: () => controller.shareArticle(article.url),
        ),
        // _buildActionIcon(
        //   icon: Icons.open_in_browser_outlined,
        //   color: Colors.white,
        //   onPressed: () => controller.openInBrowser(article.url),
        // ),
        // const SizedBox(width: 8),
      ],
    );
  }

  // Action Icon Button
  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Icon(icon, color: color, size: 22),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Hero Image Section
  Widget _buildHeroImage() {
    return Stack(
      children: [
        // Image
        if (article.image.isNotEmpty)
          ClipRRect(
            child: Image.network(
              article.image,
              width: double.infinity,
              height: 450,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 450,
                  width: double.infinity,
                  color: AppColors.secondary.withOpacity(0.2),
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 450,
                  width: double.infinity,
                  color: AppColors.secondary.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  ),
                );
              },
            ),
          ),

        // Gradient Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.primary.withOpacity(0.95),
                  AppColors.primary,
                ],
              ),
            ),
          ),
        ),

        // Source Badge
        if (article.source.isNotEmpty)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.newspaper, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    article.source,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // Content Section
  Widget _buildContentSection(ArticleController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16),

          // Meta Info Row
          _buildMetaInfo(),

          const SizedBox(height: 24),

          // Description Section
          _buildSection(
            title: "About This Article",
            icon: Icons.description_outlined,
            content: article.description.isNotEmpty
                ? article.description
                : "No description available for this article",
          ),

          const SizedBox(height: 24),

          // Content Section
          _buildSection(
            title: "News Detail",
            icon: Icons.article_outlined,
            content: article.content.isNotEmpty
                ? article.content
                : "No detailed content available for this article",
          ),
        ],
      ),
    );
  }

  // Meta Info Row
  Widget _buildMetaInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
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
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildMetaChip(icon: Icons.access_time, label: _getTimeAgo()),
          const SizedBox(width: 12),
          _buildMetaChip(
            icon: Icons.remove_red_eye_outlined,
            label: "Estimated 5 min read",
          ),
        ],
      ),
    );
  }

  // Meta Chip
  Widget _buildMetaChip({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.secondary, size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  // Section Widget
  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.secondary, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  String _getTimeAgo() {
    return "Published recently";
  }
}
