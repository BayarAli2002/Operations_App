import 'package:crud_app/source/features/screens/root/view/widgets/add_update_screen.dart';
import 'package:crud_app/source/features/screens/home/view/product_details_screen.dart';
import 'package:crud_app/source/features/screens/root/view/splash_screen.dart';

class Routes {
  static const String splashScreen = '/';
  static const String addUpdateProduct = '/add_update_Product';
  static const String productDetails = '/productDetails';
}

class RoutesManager {
  final routes = {
    Routes.splashScreen: (context) => const SplashScreen(),
    Routes.addUpdateProduct: (context) => const AddUpdateProductScreen(),
    Routes.productDetails: (context) => const ProductDetailsScreen(), 
  };
}
