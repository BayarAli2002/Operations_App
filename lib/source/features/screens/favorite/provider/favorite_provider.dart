import 'dart:developer';
import 'package:crud_app/source/core/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../home/data/model/product_model.dart';
import '../data/repo/favorite_remote_repo.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRemoteRepo favoriteRemoteRepo;

  FavoriteProvider({required this.favoriteRemoteRepo});

  final List<ProductModel> _favoriteProducts = [];
  List<ProductModel> get favoriteProducts => _favoriteProducts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    _setLoading(true);

    final result = await favoriteRemoteRepo.fetchFavorites();

    result.fold(
      (failure) {
        Utils.showToast(failure.message,ToastType.error);
        log('Fetch favorites failed: ${failure.message}');
      },
      (data) {
        _favoriteProducts
          ..clear()
          ..addAll(data);
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> addFavorite(ProductModel product) async {
    final exists = _favoriteProducts.any((p) => p.id == product.id);
    if (exists) return;

    final result = await favoriteRemoteRepo.addFavorite(product);

    result.fold(
      (failure) {
        Utils.showToast(failure.message, ToastType.error);
        log('Add favorite failed: ${failure.message}');
      },
      (addedProduct) {
        _favoriteProducts.insert(0, addedProduct);
        notifyListeners();
      },
    );
  }

  Future<void> removeFavorite(String productId) async {
    final product = _favoriteProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => ProductModel(),
    );

    if (product.favoriteId == null) return;

    final result = await favoriteRemoteRepo.removeFavorite(product.favoriteId!);

    result.fold(
      (failure) {
        Utils.showToast(failure.message, ToastType.error);
        log('Remove favorite failed: ${failure.message}');
      },
      (_) {
        _favoriteProducts.removeWhere((p) => p.id == productId);
        notifyListeners();
      },
    );
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.any((p) => p.id == productId);
  }
}
