import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:crud_app/source/core/api/error_handling.dart';
import 'package:crud_app/source/core/api/failure.dart';
import 'package:crud_app/source/core/services/base_local_client.dart';

class FavoriteLocalRepo {

  final BaseLocalClient localClient;

  FavoriteLocalRepo({required this.localClient});

  static const String _favoriteKey = 'favorite_key';


  /// Save favorite data to local cache
  Future<Either<Failure, Unit>> saveFavorite(Map<String, dynamic> favoriteData) async {
    try {
      await localClient.saveCache(_favoriteKey, favoriteData);
      return right(unit);
    } catch (e) {
      log("saveFavorite() error: $e");
      return left(Failure(ErrorHandling.handleError(e)));
    }
  }


  /// Get favorite data from local cache
  Either<Failure, Map<String, dynamic>?> getFavorite() {
    try {
      final data = localClient.getCache(_favoriteKey);
      return right(data);
    } catch (e) {
      log("getFavorite() error: $e");
      return left(Failure(ErrorHandling.handleError(e)));
    }
  }

  /// Clear favorite data from local cache  
  Future<Either<Failure, Unit>> clearFavorite() async {
    try {
      await localClient.clearCache(_favoriteKey);
      return right(unit);
    } catch (e) {
      log("clearFavorite() error: $e");
      return left(Failure(ErrorHandling.handleError(e)));
    }
  }


  /// Check if favorite data exists in cache
  Either<Failure, bool> hasFavorite() {
    try {
      final hasData = localClient.hasCache(_favoriteKey);
      return right(hasData);
    } catch (e) {
      log("hasFavorite() error: $e");
      return left(Failure(ErrorHandling.handleError(e)));
    }
  }

  
}
