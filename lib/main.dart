import 'package:crud_app/app/di/dependency_injections.dart';
import 'package:crud_app/features/screens/favorite/provider/favorite_provider.dart';
import 'package:crud_app/features/screens/home/provider/product_provider.dart';
import 'package:crud_app/features/screens/home/view/product_details/product_details_screen.dart';
import 'package:crud_app/features/screens/splash_screen/splash_screen.dart';

import 'package:crud_app/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import 'core/routes/routs.dart';
import 'core/static_texts/language.dart';
import 'features/common_widgets/add_update_product.dart';

void main() async {
  DependencyInjection.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale(Language.englishLocale),
        Locale(Language.arabicLocale),
        Locale(Language.kurdishLocale),
      ],
      path: "assets/languages",
      //Default locale(Language)
      fallbackLocale: Locale(Language.defaultLanguage),
      assetLoader: CodegenLoader(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => DependencyInjection.sl<ProductProvider>(),
          ),
          ChangeNotifierProvider(
            create: (_) => DependencyInjection.sl<FavoriteProvider>(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}
