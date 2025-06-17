import 'package:crud_app/core/api/base_api_client.dart';
import 'package:crud_app/core/end_points/end_points.dart';

import 'package:crud_app/features/screens/home/data/model/product_model.dart';

class FavoriteRemoteRepo {
  final BaseApiClient client;

  FavoriteRemoteRepo({required this.client});

  Future<List<ProductModel>> fetchFavorites() async {
    final response = await client.get(EndPoints.favoriteProducts);
    return (response as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel> addFavorite(ProductModel product) async {
    final response = await client.post(
      EndPoints.addFavoriteProduct,
      data: {...product.toJson(), 'productId': product.id},
    );

    return ProductModel.fromJson(response.data);
  }

  Future<void> removeFavorite(String favoriteId) async {
    await client.delete('${EndPoints.deleteFavoriteProduct}/$favoriteId');
  }
}
