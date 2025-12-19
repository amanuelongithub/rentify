import 'package:get/get.dart';
import 'package:yegnabet/views/details_page.dart';
import 'package:yegnabet/views/filter_page.dart';
import 'package:yegnabet/views/home_page.dart';

class Routes {
  static final routes = [
    // GetPage(name: SplashScreen.route, page: () => const SplashScreen(), transition: Transition.cupertino),
    // GetPage(name: OnboardingPage.route, page: () => const OnboardingPage()),
    // GetPage(name: LoginPage.route, page: () => const LoginPage(), transition: Transition.cupertino),
    // GetPage(name: SignupPage.route, page: () => const SignupPage(), transition: Transition.cupertino),
    GetPage(name: HomePage.route, page: () => const HomePage(), transition: Transition.downToUp),
    GetPage(name: DetailsPage.route, page: () => const DetailsPage(), transition: Transition.downToUp),
    GetPage(name: FilterPage.route, page: () => const FilterPage(), transition: Transition.downToUp),
  ];
}
