import 'package:crud_app/core/api/base_api_client.dart';
import 'package:crud_app/core/end_points/end_points.dart';
import '../model/product_model.dart';

class ProductRemoteRepo {
  final BaseApiClient client;
  ProductRemoteRepo({required this.client});

  Future<List<ProductModel>> fetchProducts() async {
    final response = await client.get(EndPoints.getProducts);
    return (response.data as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  Future<ProductModel> fetchProductById(String id) async {
    final response = await client.get(EndPoints.productById(id));
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      EndPoints.addProduct,
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(String id, ProductModel product) async {
    final response = await client.put(
      EndPoints.updateProduct(id),
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(String id) async {
    await client.delete(EndPoints.deleteProduct(id));
  }
}
