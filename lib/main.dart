

import 'package:crud_app/source/app/di/dependency_injections.dart';
import 'package:crud_app/source/app/view/app.dart';
import 'package:crud_app/source/features/screens/favorite/provider/favorite_provider.dart';
import 'package:crud_app/source/features/screens/home/provider/product_provider.dart';
import 'package:crud_app/translations/codegen_loader.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'package:provider/provider.dart';


import 'Source/core/static_texts/language.dart';


void main() async {
  // Set status bar appearance
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // or any color like Colors.blue
      statusBarIconBrightness:
          Brightness.dark, // dark icons for light background
      statusBarBrightness: Brightness.light, // required for iOS
    ),
  );
  DependencyInjection.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // Only portrait mode
    //DeviceOrientation.portraitDown,  // optional if you want to allow upside-down portrait
  ]);
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
        child: const App(),
      ),
    ),
  );
}
