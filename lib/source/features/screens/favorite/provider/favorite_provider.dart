import 'dart:developer';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:crud_app/source/core/utils/utils.dart';
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
        Utils.showToast(failure.message, ToastType.error);
        log('Fetch favorites failed: ${failure.message}');
      },
      (response) {
        final data = response.data;
        if (data is List) {
          final mapped = data.map((e) => ProductModel.fromJson(e)).toList();
          _favoriteProducts
            ..clear()
            ..addAll(mapped);
          Utils.showToast(LocaleKeys.favorites_fetched.tr(), ToastType.success);
        } else {
          Utils.showToast('Unexpected data format', ToastType.error);
          log('${LocaleKeys.unexpected_data_format.tr()}: ${data.runtimeType}');
        }
        notifyListeners();
      },
    );

    _setLoading(false);
  }

  Future<void> addFavorite(ProductModel product) async {
    final exists = _favoriteProducts.any((p) => p.id == product.id);
    if (exists) return;

    final result = await favoriteRemoteRepo.addFavorite({
      ...product.toJson(),
      'productId': product.id,
    });

    result.fold(
      (failure) {
        Utils.showToast(failure.message, ToastType.error);
        log('Add favorite failed: ${failure.message}');
      },
      (response) {
        final addedProduct = ProductModel.fromJson(response.data);
        _favoriteProducts.insert(0, addedProduct);
        Utils.showToast(LocaleKeys.favorite_added, ToastType.success);
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
      (response) {
        _favoriteProducts.removeWhere((p) => p.id == productId);
        Utils.showToast(LocaleKeys.favorite_removed, ToastType.success);
        notifyListeners();
      },
    );
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.any((p) => p.id == productId);
  }
}
