import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/source/core/utils/utils.dart';
import '../data/model/product_model.dart';
import '../data/repo/product_remote_repo.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRemoteRepo productRemoteRepo;

  ProductProvider({required this.productRemoteRepo});

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  ProductModel? _selectedProduct;
  ProductModel? get selectedProduct => _selectedProduct;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _setLoading(true);
    final result = await productRemoteRepo.fetchProducts();
    result.fold(
      (failure) => Utils.showToast(failure.message, ToastType.error),
      (response) {
        final data = response.data as List;
        _products = data.map((e) => ProductModel.fromJson(e)).toList();
        Utils.showToast(LocaleKeys.products_fetched.tr(), ToastType.success);
      },
    );
    _setLoading(false); // Already notifies listeners
  }

  Future<void> fetchProductById(String id) async {
    _setLoading(true);
    _selectedProduct = null;
    notifyListeners(); // No need to notify here yet

    final result = await productRemoteRepo.fetchProductById(id);
    result.fold(
      (failure) => Utils.showToast(failure.message, ToastType.error),
      (response) {
        _selectedProduct = ProductModel.fromJson(response.data);
        Utils.showToast(LocaleKeys.product_details_fetched.tr(), ToastType.success);
      },
    );
    _setLoading(false); // Notifies once after assignment
  }

  Future<void> addProduct(ProductModel product) async {
    final result = await productRemoteRepo.addProduct(product.toJson());

    result.fold(
      (failure) => Utils.showToast(failure.message, ToastType.error),
      (response) {
        final addedProduct = ProductModel.fromJson(response.data);
        _products.add(addedProduct);
        notifyListeners();
        Utils.showToast(LocaleKeys.product_added.tr(), ToastType.success);
      },
    );
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    final result = await productRemoteRepo.updateProduct(id, product.toJson());

    result.fold(
      (failure) => Utils.showToast(failure.message, ToastType.error),
      (response) {
        final updatedProduct = ProductModel.fromJson(response.data);
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
          Utils.showToast(LocaleKeys.product_updated.tr(), ToastType.success);
        }
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    final result = await productRemoteRepo.deleteProduct(id);

    result.fold(
      (failure) => Utils.showToast(failure.message, ToastType.error),
      (_) {
        _products.removeWhere((p) => p.id == id);
        Utils.showToast(LocaleKeys.productDeleted.tr(), ToastType.success);
        notifyListeners();
      },
    );
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}
