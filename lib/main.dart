import 'package:crud_app/source/app/dependency_injection.dart';
import 'package:crud_app/source/app/app.dart';
import 'package:crud_app/source/features/screens/home/provider/product_provider.dart';
import 'package:crud_app/source/features/screens/root/provider/root_provider.dart';
import 'package:crud_app/source/features/screens/root/provider/theme_provider.dart';
import 'package:crud_app/source/core/translations/codegen_loader.g.dart';
import 'package:crud_app/source/core/translations/language.dart';
import 'package:crud_app/source/features/screens/favorite/provider/favorite_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {

  //this should be called first
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies (Dio, Repos, Providers, etc.)
  await DependencyInjection.init();

  
  String? token="Bayar"; // or null if not logged in

  await EasyLocalization.ensureInitialized();

  // Lock device orientation to portrait
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      
    ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale(Language.englishLocale),
        Locale(Language.arabicLocale),
        Locale(Language.kurdishLocale),
      ],
      path: Language.languagePath,
      fallbackLocale: Locale(Language.defaultLanguage),
      assetLoader: CodegenLoader(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => sl<ProductProvider>()),
          ChangeNotifierProvider(
            create: (_) {
              final favoriteProvider = sl<FavoriteProvider>();
              favoriteProvider.setToken(token);
              // Load favorites after setting the token
              favoriteProvider.loadFavorites();
              return favoriteProvider;
            },
          ),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => RootProvider()),
        ],
        child: const App(),
      ),
    ),
  );
}
