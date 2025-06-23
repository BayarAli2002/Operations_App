import 'dart:developer';
import 'package:dartz/dartz.dart';
import '../../../../../core/api/base_api_client.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/api/error_handling.dart';
import '../../../../../core/api/failure.dart';
import 'package:dio/dio.dart';

class FavoriteRemoteRepo {
  final BaseApiClient client;

  FavoriteRemoteRepo({required this.client});

  Future<Either<Failure, Response>> fetchFavorites() async {
    try {
      final response = await client.get(EndPoints.favoriteProducts);
      return Right(response);
    } catch (e) {
      log("fetchFavorites() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> addFavorite(Map<String, dynamic> data) async {
    try {
      final response = await client.post(
        EndPoints.addFavoriteProduct,
        data: data,
      );
      return Right(response);
    } catch (e) {
      log("addFavorite() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> removeFavorite(String favoriteId) async {
    try {
      final response = await client.delete(EndPoints.deleteFavoriteProduct(favoriteId));
      return Right(response);
    } catch (e) {
      log("removeFavorite() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }
}
