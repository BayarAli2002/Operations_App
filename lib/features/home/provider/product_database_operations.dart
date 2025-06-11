import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/error_handling/dio_exception_erros.dart';
import '../../../core/static_texts/request_texts.dart';
import '../model/product_model.dart';
import 'package:crud_app/core/end_points/end_points.dart';

class ProductProvider extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: EndPoints.baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: { RequestTexts.contentType: RequestTexts.applicationJson},
  ));

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;

  // Centralized error handling
  void _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      throw Exception(DioExceptionErrors.connectionTimeout);
    } else if (e.type == DioExceptionType.receiveTimeout) {
      throw Exception(DioExceptionErrors.receiveTimeout);
    } else if (e.type == DioExceptionType.badResponse) {
      throw Exception('${DioExceptionErrors.badresponse}: ${e.response?.statusCode}');
    } else {
      throw Exception('${DioExceptionErrors.unknown}: $e');
    }
  }

  // GET: Fetch all products
  Future<void> fetchProducts() async {
    try {
      Response response = await _dio.get(EndPoints.getProducts);
      print('API Response: ${response.data}'); //  Debugging - check if products exist
      _products = (response.data as List)
          .map((item) => ProductModel.fromJson(item))
          .toList();
      notifyListeners();
    } on DioException catch (e) {
      print('Error fetching products: $e'); // ✅ Log errors if any
      _handleError(e);
    }
  }

  // GET: Fetch a single product by ID
  Future<void> fetchProductById(String productId) async {
    try {
      Response response = await _dio.get(EndPoints.productById(productId));
      _selectedProduct = ProductModel.fromJson(response.data);
      notifyListeners();
    } on DioException catch (e) {
      print("Error: $e"); //for debugging
      _handleError(e);
    }
  }

  // POST: Add a new product
  Future<void> addProduct(ProductModel product) async {
    try {
      Response response = await _dio.post(EndPoints.addProduct, data: product.toJson());
      _products.add(ProductModel.fromJson(response.data));
      notifyListeners();
    } on DioException catch (e) {
      print("Error:$e");
      _handleError(e);
    }
  }

  // PUT: Update an existing product
  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      Response response = await _dio.put(EndPoints.updateProduct(productId), data: product.toJson());
      int index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = ProductModel.fromJson(response.data);
        notifyListeners();
      }
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // DELETE: Remove a product
  Future<void> deleteProduct(String productId) async {
    try {
      await _dio.delete(EndPoints.deleteProduct(productId));
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } on DioException catch (e) {
      print("Error: $e");
      _handleError(e);
    }
  }
}