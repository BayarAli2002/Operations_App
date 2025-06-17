import 'dart:developer';
import 'package:crud_app/core/error_handling/dio_exception_erros.dart';
import 'package:flutter/material.dart';

import '../data/model/product_model.dart';
import '../data/repo/product_remote_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRemoteRepo remoteDataSource;

  ProductProvider({required this.remoteDataSource});

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;

  // Error Handling
  void _handleError(dynamic e) {
    if (e.toString().contains('Timeout')) {
      throw Exception(DioExceptionErrors.connectionTimeout);
    } else {
      throw Exception('${DioExceptionErrors.unknown}: $e');
    }
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      _products = await remoteDataSource.fetchProducts();
      notifyListeners();
    } catch (e) {
      log('Error fetching products: $e');
      _handleError(e);
    }
  }

  // Fetch single product
  Future<void> fetchProductById(String productId) async {
    _selectedProduct = null;
    try {
      _selectedProduct = await remoteDataSource.fetchProductById(productId);
      notifyListeners();
    } catch (e) {
      log('Error fetching product by ID: $e');
      _handleError(e);
    }
  }

  // Add product
  Future<void> addProduct(ProductModel product) async {
    try {
      final newProduct = await remoteDataSource.addProduct(product);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      log('Error adding product: $e');
      _handleError(e);
    }
  }

  // Update product
  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      final updatedProduct = await remoteDataSource.updateProduct(
        productId,
        product,
      );
      int index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      log('Error updating product: $e');
      _handleError(e);
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await remoteDataSource.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      log('Error deleting product: $e');
      _handleError(e);
    }
  }
}
