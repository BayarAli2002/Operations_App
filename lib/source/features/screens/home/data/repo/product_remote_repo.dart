import 'dart:developer';
import 'package:crud_app/source/core/api/error_handling.dart';
import 'package:crud_app/source/core/api/failure.dart';
import 'package:crud_app/source/features/screens/home/data/model/product_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/api/base_api_client.dart';
import '../../../../../core/api/end_points.dart';

class ProductRemoteRepo {
  final BaseApiClient baseApiClient;

  ProductRemoteRepo({required this.baseApiClient});

  Future<Either<Failure, Response>> fetchProducts() async {
    try {
      final response = await baseApiClient.get(EndPoints.getProducts);
      return Right(response);
    } catch (e) {
      log("fetchProducts() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> fetchProductById(String id) async {
    try {
      final response = await baseApiClient.get(EndPoints.productById(id));
      return Right(response);
    } catch (e) {
      log("fetchProductById() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> addProduct(ProductModel data) async {
    try {
      final response = await baseApiClient.post(EndPoints.addProduct, data: data.toJson());
      return Right(response);
    } catch (e) {
      log("addProduct() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> updateProduct(String id, ProductModel data) async {
    try {
      final response = await baseApiClient.put(EndPoints.updateProduct(id), data: data.toJson());
      return Right(response);
    } catch (e) {
      log("updateProduct() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> deleteProduct(String id) async {
    try {
      final response = await baseApiClient.delete(EndPoints.deleteProduct(id));
      return Right(response);
    } catch (e) {
      log("deleteProduct() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }
}
