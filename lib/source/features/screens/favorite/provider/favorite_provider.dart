import 'dart:developer';
import 'package:crud_app/source/features/screens/home/data/model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:crud_app/source/core/utils/utils.dart';
import 'package:crud_app/source/core/translations/local_keys.g.dart';
import '../data/repo/favorite_local_repo.dart';
import '../data/repo/favorite_remote_repo.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRemoteRepo favoriteRemoteRepo;
  final FavoriteLocalRepo favoriteLocalRepo;

  FavoriteProvider({
    required this.favoriteRemoteRepo,
    required this.favoriteLocalRepo,
  });

  final List<ProductModel> _favoriteProducts = [];
  List<ProductModel> get favoriteProducts => _favoriteProducts;

  Map<String, dynamic>? _favoriteCache;
  Map<String, dynamic>? get favoriteCache => _favoriteCache;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _token;
  bool get isUserLoggedIn => _token != null && _token!.isNotEmpty;



  void setToken(String? token) {
    _token = token;
    notifyListeners();
  }


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// ===========================================================================
  /// Load Favorites - Decides between Remote or Local
  /// ===========================================================================
  Future<void> loadFavorites() async {
    if (isUserLoggedIn) {
      await _fetchRemoteFavorites();
    } else {
      _fetchLocalFavorites();
    }
  }


  //this function dedcides to take action based on the user's login status
  Future<void> toggleFavorite(ProductModel product) async {
    final isFav = isFavorite(product.id ?? '');

    if (isUserLoggedIn) {
      isFav
          ? await removeFavorite(product.id ?? '')
          : await addFavorite(product);
    } else {
      final index = _favoriteProducts.indexWhere((p) => p.id == product.id);
      isFav
          ? await removeFavoriteLocally(index)
          : await addFavoriteLocally(product);
    }
  }

  /// ===========================================================================
  /// Remote Methods
  /// ===========================================================================

  /// Fetch from API and sync to local cache
  Future<void> _fetchRemoteFavorites() async {
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

  /// Add favorite to remote server
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

  /// Remove favorite from remote server
  Future<void> removeFavorite(String productId) async {
    final product = _favoriteProducts.firstWhere(
      (p) => p.id == productId,
      //orElse for null safety check
      //if product is not found, return an empty product model instaed of crashing the
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

  /// ===========================================================================
  /// Local/Cache Methods
  /// ===========================================================================

  /// Load favorites from local storage
  void _fetchLocalFavorites() {
    final result = favoriteLocalRepo.getFavorite();
    result.fold(
      (fail) {
        Utils.showToast(fail.message, ToastType.error);
        _favoriteProducts.clear();
      },
      (map) {
        _favoriteCache = map;
        if (map != null && map['favorites'] is List) {
          _favoriteProducts
            ..clear()
            ..addAll(
              (map['favorites'] as List).map((e) => ProductModel.fromJson(e)),
            );
        }
        Utils.showToast("Loaded saved favorites", ToastType.success);
      },
    );
    notifyListeners();
  }

  /// Add favorite for guest/local users
  Future<void> addFavoriteLocally(ProductModel product) async {
    _favoriteProducts.insert(0, product);
    await saveFavoriteCache({
      'favorites': _favoriteProducts.map((p) => p.toJson()).toList(),
    });
    Utils.showToast(LocaleKeys.favorite_added.tr(), ToastType.success);
    notifyListeners();
  }

  /// Remove favorite for guest/local users
  Future<void> removeFavoriteLocally(int index) async {
    _favoriteProducts.removeAt(index);
    await saveFavoriteCache({
      'favorites': _favoriteProducts.map((p) => p.toJson()).toList(),
    });
    Utils.showToast(LocaleKeys.favorite_removed.tr(), ToastType.success);
    notifyListeners();
  }

  /// Save favorites to local storage
  Future<void> saveFavoriteCache(Map<String, dynamic> data) async {
    _setLoading(true);
    final result = await favoriteLocalRepo.saveFavorite(data);
    result.fold(
      (fail) => Utils.showToast(fail.message, ToastType.error),
      (success) => _favoriteCache = data,
    );
    _setLoading(false);
  }

  /// Clear local cache completely
  Future<void> clearFavoriteCache() async {
    _setLoading(true);
    final result = await favoriteLocalRepo.clearFavorite();
    result.fold(
      (fail) => Utils.showToast(fail.message, ToastType.error),
      (success) => _favoriteCache = null,
    );
    _setLoading(false);
    notifyListeners();
  }

  /// ===========================================================================
  /// Utilities
  /// ===========================================================================

  /// Check if product is already a favorite
  bool isFavorite(String productId) =>
      _favoriteProducts.any((p) => p.id == productId);

  
}
