import 'dart:developer';

import 'package:crud_app/source/core/api/error_handling.dart';
import 'package:crud_app/source/core/api/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/api/base_api_client.dart';
import '../../../../../core/api/end_points.dart';

import '../model/product_model.dart';

class ProductRemoteRepo {
  final BaseApiClient client;

  ProductRemoteRepo({required this.client});

  Future<Either<Failure, List<ProductModel>>> fetchProducts() async {
    try {
      final response = await client.get(EndPoints.getProducts);
      final products = (response.data as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
      return Right(products);
    } catch (e) {
      //for debugging
      log("Error in fetchProductById(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }

  Future<Either<Failure, ProductModel>> fetchProductById(String id) async {
    try {
      final response = await client.get(EndPoints.productById(id));
      return Right(ProductModel.fromJson(response.data));
    } catch (e) {
      //for debugging
      log("Error in fetchProductById(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }

  Future<Either<Failure, ProductModel>> addProduct(ProductModel product) async {
    try {
      final response = await client.post(
        EndPoints.addProduct,
        data: product.toJson(),
      );
      return Right(ProductModel.fromJson(response.data));
    } catch (e) {
      //for debugging
      log("Error in fetchProductById(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }

  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    ProductModel product,
  ) async {
    try {
      final response = await client.put(
        EndPoints.updateProduct(id),
        data: product.toJson(),
      );
      return Right(ProductModel.fromJson(response.data));
    } catch (e) {
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }

  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      await client.delete(EndPoints.deleteProduct(id));
      return Right(unit); // `unit` represents a void success response in dartz
    } catch (e) {
      //for debugging
      log("Error in fetchProductById(): $e");
      final message = ErrorHandling.handle(e);
      return Left(Failure(message));
    }
  }
}
