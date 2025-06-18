import 'package:flutter/material.dart';
import '../../home/data/model/product_model.dart';
import '../data/repo/favorite_remote_repo.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRemoteRepo remoteRepo;

  FavoriteProvider({required this.remoteRepo});

  final List<ProductModel> _favoriteProducts = [];
  List<ProductModel> get favoriteProducts => _favoriteProducts;

  Future<void> fetchFavorites() async {
    try {
      final data = await remoteRepo.fetchFavorites();
      _favoriteProducts.
        addAll(data);
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to fetch favorites: $e');
    }
  }

  Future<void> addFavorite(ProductModel product) async {
    final exists = _favoriteProducts.any((p) => p.id == product.id);
    if (!exists) {
      try {
        final added = await remoteRepo.addFavorite(product);
        _favoriteProducts.insert(0,added);
        notifyListeners();
      } catch (e) {
        debugPrint('Failed to add favorite: $e');
      }
    }
  }

  Future<void> removeFavorite(String productId) async {
    try {
      final favorite = _favoriteProducts.firstWhere((p) => p.id == productId);
      if (favorite.favoriteId != null) {
        await remoteRepo.removeFavorite(favorite.favoriteId!);
        _favoriteProducts.removeWhere((p) => p.id == productId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to remove favorite: $e');
    }
  }

  bool isFavorite(String productId) {
    return _favoriteProducts.any((p) => p.id == productId);
  }
}