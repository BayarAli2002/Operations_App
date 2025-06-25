import 'package:crud_app/source/features/screens/home/view/home_screen.dart';
import 'package:crud_app/source/features/screens/root/view/add_update_screen.dart';
import 'package:crud_app/source/features/screens/home/view/product_details_screen.dart';
import 'package:crud_app/source/features/screens/root/view/bottom_navigation_bar.dart';
import 'package:crud_app/source/features/screens/root/view/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String bottomNavigationBar = '/bottom_navigation_bar';
  static const String addUpdateProduct = '/add_update_Product';
  static const String productDetails = '/productDetails';
  static const String loginScreen = '/login';
  static const String homeScreen = '/home';
  static const String signUpScreen = '/signup';
}

class RoutesManager {
  final routes = {
    Routes.splashScreen: (context) => const SplashScreen(),
    Routes.bottomNavigationBar: (context) => const BottomNavigationBarScreens(),
    Routes.addUpdateProduct: (context) => const AddUpdateProductScreen(),
    Routes.productDetails: (context) => const ProductDetailsScreen(), 
    Routes.homeScreen: (context) => const HomeScreen(),
 
  };
}
