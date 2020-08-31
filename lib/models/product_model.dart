import 'category_model.dart';

class Product {
  String id;
  String title;
  String description;
  int price;
  int stock;
  List images;
  List sizes;
  Category category;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.stock,
    this.images,
    this.sizes,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        stock: json['stock'],
        images: json['images'],
        sizes: json['sizes'],
        category: Category.fromMap(json['category']),
      );

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'images': images,
      'sizes': sizes,
      'category': category,
    };
  }
}
