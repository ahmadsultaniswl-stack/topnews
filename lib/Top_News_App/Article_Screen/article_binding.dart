import 'package:get/get.dart';
import 'package:top_news/Top_News_App/Article_Screen/article_controller.dart';

class MarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleController());
  }
}
