import 'package:crud_app/source/core/utils/utils.dart';
import 'package:flutter/material.dart';
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
      (failure) {
    
        Utils.showToast(failure.message,ToastType.error);
      },
      (products) {
        _products = products;
      },
    );

    _setLoading(false);
  }

  Future<void> fetchProductById(String id) async {
    _setLoading(true);
    _selectedProduct = null;
    notifyListeners();

    final result = await productRemoteRepo.fetchProductById(id);

    result.fold(
      (failure) {
       Utils.showToast(failure.message,ToastType.error);
      },
      (product) {
        _selectedProduct = product;
      },
    );

    _setLoading(false);
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    final result = await productRemoteRepo.addProduct(product);

    result.fold(
      (failure) {
        Utils.showToast(failure.message, ToastType.error);
        notifyListeners();
      },
      (addedProduct) {
        _products.add(addedProduct);
        notifyListeners();
      },
    );
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    final result = await productRemoteRepo.updateProduct(id, product);

    result.fold(
      (failure) {
       Utils.showToast(failure.message, ToastType.error);
        notifyListeners();
      },
      (updatedProduct) {
        int index = _products.indexWhere((p) => p.id == id);
        if (index != -1) {
          _products[index] = updatedProduct;
          notifyListeners();
        }
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    final result = await productRemoteRepo.deleteProduct(id);

    result.fold(
      (failure) {
       Utils.showToast(failure.message, ToastType.error);
        notifyListeners();
      },
      (_) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      },
    );
  }
}
