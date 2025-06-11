class ProductModel{
   final String? favorite_id; // This is the original product ID from the API
  final String? id;
  final String? title;
  final double? price;
  final String? image;
  final String? description;
  ProductModel({
    this.favorite_id,
    this.id,
    this.title,
    this.price,
    this.image,
    this.description,

});
  //Special Constructor to convert json data from API to dart objects then we can simply deal with the data
  factory ProductModel.fromJson(Map<String,dynamic> json){
    return ProductModel(
      id: json['id'],
      favorite_id: json['favorite_id'], // Use 'productId' for the original product ID
      title: json['title'],
      price: (json['price'] ).toDouble(),
      image: json['image'],
      description: json['description'],
    );

  }
  //to convert the data to a JSON API format which is a Map of key and value pairs
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "favorite_id": favorite_id, // Use 'productId' for the original product ID
      "title": title,
      "price": price,
      "image": image,
      "description": description,
    };
  }
}