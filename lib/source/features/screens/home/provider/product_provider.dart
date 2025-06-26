import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:crud_app/source/core/utils/netwotk_utils.dart';
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

  // Add private error message field and public getter
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Add private setter for error message, notify listeners
  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _setLoading(true);
    _setError(null); // clear any previous error

    try {
      final hasInternet = await ConnectivityHelper.ensureHasInternet();
      if (!hasInternet) {
        _setError("No internet access");
        return;
      }

      final result = await productRemoteRepo.fetchProducts();
      result.fold(
        (failure) {
          _setError(failure.message);
          Utils.showToast(failure.message, ToastType.error);
        },
        (response) {
          final data = response.data as List;
          _products = data.map((e) => ProductModel.fromJson(e)).toList();
          Utils.showToast(LocaleKeys.products_fetched.tr(), ToastType.success);
        },
      );
    } catch (e) {
      final msg = "Unexpected error occurred.$e";
      _setError(msg);
      Utils.showToast(msg, ToastType.error);
    } finally {
      _setLoading(false); // ensures UI stops loading
    }
  }

  // Other methods unchanged
  Future<void> fetchProductById(String id) async {
    _setLoading(true);
    clearSelectedProduct();
    final result = await productRemoteRepo.fetchProductById(id);
    result.fold(
      (failure) => Utils.showToast(failure.message, ToastType.error),
      (response) {
        _selectedProduct = ProductModel.fromJson(response.data);
        Utils.showToast(
          LocaleKeys.product_details_fetched.tr(),
          ToastType.success,
        );
      },
    );
    _setLoading(false);
  }

  Future<void> addProduct(ProductModel product) async {
    final result = await productRemoteRepo.addProduct(product);

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
    final result = await productRemoteRepo.updateProduct(id, product);

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
