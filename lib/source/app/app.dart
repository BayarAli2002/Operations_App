import 'package:crud_app/source/features/screens/root/view/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../features/screens/home/view/add_update_screen.dart';
import '../features/screens/home/view/product_details_screen.dart';
import 'routs.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), // Base design size (e.g., iPhone 13)
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          initialRoute: Routes.initialRoute,
          routes: {
            Routes.addUpdateProduct: (context) =>
                const AddUpdateProductScreen(),
            Routes.productDetails: (context) => const ProductDetailsScreen(),
          },
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: true,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}
