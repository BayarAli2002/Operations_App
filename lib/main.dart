import 'package:crud_app/features/common_widgets/bottom_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';

import 'features/favorite/provider/favorite_provider.dart';
import 'features/home/provider/product_database_operations.dart';
import 'features/home/view/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => FavoriteProvider()),
          ],
          child: const MyApp(),
        ),
        supportedLocales: [
          Locale("en"),
          Locale("ar"),
          Locale("fa"),
        ],
        path: "assets/languages",
      //Default locale(Language)
      fallbackLocale: Locale("en"),
    )
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
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: child,
        );
      },
      child:  BottomNavigationBarScreens(),
    );
  }
}
