import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../../core/api/error_handling.dart';
import '../data/model/product_model.dart';
import '../data/repo/product_remote_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRemoteRepo productRemoteRepo;

  ProductProvider({required this.productRemoteRepo});

  List<ProductModel> _products = [];
  ProductModel? _selectedProduct;

  List<ProductModel> get products => _products;
  ProductModel? get selectedProduct => _selectedProduct;

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      _products = await productRemoteRepo.fetchProducts();
      notifyListeners();
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Error fetching products: $error');
      throw Exception(error);
    }
  }

  // Fetch single product
  Future<void> fetchProductById(String productId) async {
    _selectedProduct = null;
    notifyListeners();
    try {
      _selectedProduct = await productRemoteRepo.fetchProductById(productId);
      notifyListeners();
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Error fetching product by ID: $error');
      throw Exception(error);
    }
  }

  // Add product
  Future<void> addProduct(ProductModel product) async {
    try {
      final newProduct = await productRemoteRepo.addProduct(product);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Error adding product: $error');
      throw Exception(error);
    }
  }

  // Update product
  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      final updatedProduct = await productRemoteRepo.updateProduct(
        productId,
        product,
      );
      int index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Error updating product: $error');
      throw Exception(error);
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await productRemoteRepo.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Error deleting product: $error');
      throw Exception(error);
    }
  }
}
