import 'package:get/get.dart';
import 'package:top_news/Top_News_App/About_Us/about_bind.dart';
import 'package:top_news/Top_News_App/About_Us/about_view.dart';
import 'package:top_news/Top_News_App/Bookmark_Screen/mark_binding.dart';
import 'package:top_news/Top_News_App/Bookmark_Screen/mark_view.dart';
import 'package:top_news/Top_News_App/Explore_Screen/explore_binding.dart';
import 'package:top_news/Top_News_App/Explore_Screen/explore_view.dart';
import 'package:top_news/Top_News_App/Fetch_Profile/fetch_binding.dart';
import 'package:top_news/Top_News_App/Fetch_Profile/fetch_profile.dart';
import 'package:top_news/Top_News_App/Home_Screen/home_binding.dart';
import 'package:top_news/Top_News_App/Home_Screen/home_view.dart';
import 'package:top_news/Top_News_App/Login_Screen/login_bind.dart';
import 'package:top_news/Top_News_App/Login_Screen/login_view.dart';
import 'package:top_news/Top_News_App/Profile_Screen/profile_binding.dart';
import 'package:top_news/Top_News_App/Profile_Screen/profile_view.dart';
import 'package:top_news/Top_News_App/Signup_Screen/signup_bind.dart';
import 'package:top_news/Top_News_App/Signup_Screen/signup_view.dart';
import 'package:top_news/Top_News_App/Splash_Screen/splash_binding.dart';
import 'package:top_news/Top_News_App/Splash_Screen/splash_view.dart';

import '../Navigation_Screen/bottom_binding.dart';
import '../Navigation_Screen/bottom_view.dart';

class AppRoutes {
  static const String initial = '/initial';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String bottom = '/bottom';
  static const String mark = '/mark';
  static const String explore = '/explore';
  static const String profile = '/profile';
  static const String fetchdata = '/fetchdata';
  static const String aboutus = '/aboutus';

  static final routes = [
    GetPage(name: initial, page: () => SplashView(), binding: SplashBinding()),
    GetPage(name: login, page: () => LoginView(), binding: LoginBinding()),
    GetPage(name: signup, page: () => SignupView(), binding: SignupBind()),
    GetPage(name: home, page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: bottom, page: () => BottomView(), binding: BottomBinding()),
    GetPage(name: mark, page: () => MarkView(), binding: MarkBinding()),
    GetPage(
      name: explore,
      page: () => ExploreView(),
      binding: ExploreBinding(),
    ),
    GetPage(
      name: profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(name: fetchdata, page: () => FetchView(), binding: FetchBinding()),
    GetPage(name: aboutus, page: () => AboutView(), binding: AboutBinding()),
  ];
}
