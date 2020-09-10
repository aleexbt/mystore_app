import 'category_model.dart';

class Product {
  String id;
  String title;
  String description;
  int price;
  int stock;
  List images;
  List sizes;
  List variants;
  Category category;
  bool available;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.stock,
    this.images,
    this.sizes,
    this.variants,
    this.category,
    this.available,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'],
        title: json['title'],
        description: json['description'],
        price: json['price'],
        stock: json['stock'],
        images: json['images'],
        sizes: json['sizes'],
        variants: json['variants'],
        category: Category.fromMap(json['category']),
        available: json['available'],
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
      'variants': variants,
      'available': available,
    };
  }
}
