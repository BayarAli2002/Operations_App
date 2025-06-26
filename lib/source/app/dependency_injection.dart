import 'package:crud_app/source/core/api/base_api_client.dart';
import 'package:crud_app/source/core/api/custom_logging_interceptor.dart';
import 'package:crud_app/source/core/api/end_points.dart';
import 'package:crud_app/source/core/api/logger_service.dart';
import 'package:crud_app/source/core/services/base_local_client.dart';
import 'package:crud_app/source/features/screens/favorite/data/repo/favorite_local_repo.dart';
import 'package:crud_app/source/features/screens/favorite/data/repo/favorite_remote_repo.dart';
import 'package:crud_app/source/features/screens/favorite/provider/favorite_provider.dart';
import 'package:crud_app/source/features/screens/home/data/repo/product_remote_repo.dart';
import 'package:crud_app/source/features/screens/home/provider/product_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
//Service Locator
final GetIt sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Base Clients
    sl.registerLazySingleton(() => BaseLocalClient(prefs: sl()));
    sl.registerLazySingleton(
      () => BaseApiClient(dio: sl(), loggingInterceptor: sl()),
    );


    //Services
  sl.registerLazySingleton<Dio>(() {
      final dio = Dio();
      dio.options.baseUrl = EndPoints.baseUrl;
      dio.options.connectTimeout = const Duration(seconds: 3);
      dio.options.receiveTimeout = const Duration(seconds: 10);
      dio.options.sendTimeout = const Duration(seconds: 3);
      dio.interceptors.add(sl<CustomLoggingInterceptor>());
      return dio;
    });
    sl.registerLazySingleton(
      () => CustomLoggingInterceptor(loggerService: sl()),
    );
    sl.registerLazySingleton(() => LoggerService(logger: sl()));
    sl.registerLazySingleton(() => Logger());
    sl.registerLazySingleton<SharedPreferences>(() => prefs);
    

    //Repos
    sl.registerLazySingleton(() => FavoriteLocalRepo(baseLocalClient: sl()));
    sl.registerLazySingleton(() => FavoriteRemoteRepo(baseApiClient: sl()));
    sl.registerLazySingleton(() => ProductRemoteRepo(baseApiClient: sl()));


    //Providers
    //registerFactory is used to return a new instance of the class everytime it is called
    sl.registerFactory(() => ProductProvider(productRemoteRepo: sl()));
    sl.registerFactory(
      () => FavoriteProvider(favoriteRemoteRepo: sl(), favoriteLocalRepo: sl()),
    );
  }
}


  /*

 Step 1: Create a private static instance
 static final FavoriteRemoteRepo _instance = FavoriteRemoteRepo._internal();

 Step 2: Provide a factory constructor that always returns the same instance

 factory FavoriteRemoteRepo() {
    return _instance;


 Step 3: Create a private named constructor
    FavoriteRemoteRepo._internal();

    */

