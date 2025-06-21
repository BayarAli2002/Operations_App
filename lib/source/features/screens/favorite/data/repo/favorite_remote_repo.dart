import '../../../../../core/api/base_api_client.dart';
import '../../../../../core/api/end_points.dart';
import '../../../home/data/model/product_model.dart';

class FavoriteRemoteRepo {
  final BaseApiClient client;

  FavoriteRemoteRepo({required this.client});

  Future<List<ProductModel>> fetchFavorites() async {
    final response = await client.get(EndPoints.favoriteProducts);
    final data = response.data;
    //this is to ensure that the data is a List
    if (data is List) {
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Expected a List but got: ${data.runtimeType}');
    }
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
