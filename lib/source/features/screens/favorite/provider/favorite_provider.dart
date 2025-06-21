import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../../core/api/error_handling.dart';
import '../../home/data/model/product_model.dart';
import '../data/repo/favorite_remote_repo.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRemoteRepo favoriteRemoteRepo;

  FavoriteProvider({required this.favoriteRemoteRepo});

  final List<ProductModel> _favoriteProducts = [];
  List<ProductModel> get favoriteProducts => _favoriteProducts;

  Future<void> fetchFavorites() async {
    try {
      final data = await favoriteRemoteRepo.fetchFavorites();
      _favoriteProducts.clear(); // clear old data to avoid duplication
      _favoriteProducts.addAll(data);
      notifyListeners();
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Failed to fetch favorites: $error');
      throw Exception(error);
    }
  }

  Future<void> addFavorite(ProductModel product) async {
    final exists = _favoriteProducts.any((p) => p.id == product.id);
    if (!exists) {
      try {
        final added = await favoriteRemoteRepo.addFavorite(product);
        _favoriteProducts.insert(0, added);
        notifyListeners();
      } catch (e) {
        final error = ErrorHandling.handle(e);
        log('Failed to add favorite: $error');
        throw Exception(error);
      }
    }
  }

  Future<void> removeFavorite(String productId) async {
    try {
      final favorite = _favoriteProducts.firstWhere((p) => p.id == productId);
      if (favorite.favoriteId != null) {
        await favoriteRemoteRepo.removeFavorite(favorite.favoriteId!);
        _favoriteProducts.removeWhere((p) => p.id == productId);
        notifyListeners();
      }
    } catch (e) {
      final error = ErrorHandling.handle(e);
      log('Failed to remove favorite: $error');
      throw Exception(error);
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.any((p) => p.id == productId);
  }
}
