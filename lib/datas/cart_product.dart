import 'package:mystore/datas/product_data.dart';

class CartProduct {
  String productId;
  String title;
  String catId;
  int qtd;
  String size;
  int price;
  String image;
  ProductData productData;

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['_id'];
    title = map['title'];
    catId = map['category']['_id'];
    qtd = map['qtd'];
    size = map['size'];
    price = map['size'];
  }

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        productId: json["productId"],
        title: json["title"],
        catId: json["catId"],
        qtd: json["qtd"],
        size: json["size"],
        price: json["price"],
        image: json["image"],
      );

  CartProduct(
      {this.productId,
      this.title,
      this.catId,
      this.qtd,
      this.size,
      this.price,
      this.image});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'catId': catId,
      'qtd': qtd,
      'size': size,
      'price': price,
      'image': image,
    };
  }

  @override
  String toString() {
    return '{"productId": "$productId", "title": "$title", "catId": "$catId", "qtd": "$qtd", "size": "$size", "price": "$price", "image": "$image"}';
  }
}
