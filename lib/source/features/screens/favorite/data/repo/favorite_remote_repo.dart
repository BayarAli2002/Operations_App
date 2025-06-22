import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../../core/api/base_api_client.dart';
import '../../../../../core/api/end_points.dart';
import '../../../../../core/api/error_handling.dart';
import '../../../../../core/api/failure.dart';
import '../../../home/data/model/product_model.dart';

class FavoriteRemoteRepo {
  final BaseApiClient client;

  FavoriteRemoteRepo({required this.client});

  Future<Either<Failure, List<ProductModel>>> fetchFavorites() async {
    try {
      final response = await client.get(EndPoints.favoriteProducts);
      final data = response.data;

      if (data is List) {
        final favorites = data.map((e) => ProductModel.fromJson(e)).toList();
        return Right(favorites);
      } else {
        return Left(Failure('Expected a List but got ${data.runtimeType}'));
      }
    } catch (e) {
        //for debugging
      log("Error in removeFavorite(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }

  Future<Either<Failure, ProductModel>> addFavorite(ProductModel product) async {
    try {
      final response = await client.post(
        EndPoints.addFavoriteProduct,
        //the three dotes are required to make the data a Map
        data: {...product.toJson(), 'productId': product.id},
      );
      return Right(ProductModel.fromJson(response.data));
    } catch (e) {
        //for debugging
      log("Error in removeFavorite(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }

  Future<Either<Failure, Unit>> removeFavorite(String favoriteId) async {
    try {
      await client.delete(EndPoints.deleteFavoriteProduct(favoriteId));
      return Right(unit);
    } catch (e) {
      //for debugging
      log("Error in removeFavorite(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }
}
