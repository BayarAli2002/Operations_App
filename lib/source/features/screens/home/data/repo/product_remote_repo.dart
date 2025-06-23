import 'dart:developer';
import 'package:crud_app/source/core/api/error_handling.dart';
import 'package:crud_app/source/core/api/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/api/base_api_client.dart';
import '../../../../../core/api/end_points.dart';

class ProductRemoteRepo {
  final BaseApiClient client;

  ProductRemoteRepo({required this.client});

  Future<Either<Failure, Response>> fetchProducts() async {
    try {
      final response = await client.get(EndPoints.getProducts);
      return Right(response);
    } catch (e) {
      log("fetchProducts() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> fetchProductById(String id) async {
    try {
      final response = await client.get(EndPoints.productById(id));
      return Right(response);
    } catch (e) {
      log("fetchProductById() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await client.post(EndPoints.addProduct, data: data);
      return Right(response);
    } catch (e) {
      log("addProduct() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await client.put(EndPoints.updateProduct(id), data: data);
      return Right(response);
    } catch (e) {
      log("updateProduct() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }

  Future<Either<Failure, Response>> deleteProduct(String id) async {
    try {
      final response = await client.delete(EndPoints.deleteProduct(id));
      return Right(response);
    } catch (e) {
      log("deleteProduct() error: $e");
      return Left(Failure(ErrorHandling.handleError(e)));
    }
  }
}
