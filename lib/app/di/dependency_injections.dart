import 'package:crud_app/core/api/base_api_client.dart';
import 'package:crud_app/features/screens/favorite/data/repo/favorite_remote_repo.dart';
import 'package:crud_app/features/screens/favorite/provider/favorite_provider.dart';
import 'package:crud_app/features/screens/home/data/repo/product_remote_repo.dart';
import 'package:crud_app/features/screens/home/provider/product_provider.dart';
import 'package:get_it/get_it.dart';

class DependencyInjection {
  static final GetIt sl = GetIt.instance;

  static void init() {
    //Providers
    sl.registerFactory(() => ProductProvider(remoteDataSource: sl()));
    sl.registerFactory(() => FavoriteProvider(remoteRepo: sl()));
    //Product Remote Data Source
    sl.registerLazySingleton(() => ProductRemoteRepo(client: sl()));
    //Favorite Remote Data Source
    sl.registerLazySingleton(() => FavoriteRemoteRepo(client: sl()));
    //Dio Client
    sl.registerLazySingleton(() => BaseApiClient());
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

}
