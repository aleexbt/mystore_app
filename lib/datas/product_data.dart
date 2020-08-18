class ProductData {
  String catId;
  String productId;
  String title;
  String description;
  int price;
  List images;
  List sizes;

  ProductData.fromMap(Map<String, dynamic> map) {
    catId = map['category']['_id'];
    productId = map['_id'];
    title = map['title'];
    description = map['description'];
    price = map['price'];
    images = map['images'];
    sizes = map['sizes'];
  }

  Map<String, dynamic> toResumedMap() {
    return {'title': title, 'description': description, 'price': price};
  }
}
