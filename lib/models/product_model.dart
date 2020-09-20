import 'category_model.dart';

class ProductVariants {
  String size;
  String storage;
  String color;
  int qtd;

  ProductVariants({
    this.size,
    this.storage,
    this.color,
    this.qtd,
  });

  factory ProductVariants.fromJson(Map<String, dynamic> json) =>
      ProductVariants(
        size: json['size'],
        storage: json['storage'],
        color: json['color'],
        qtd: json['qtd'],
      );
}

class Product {
  String id;
  String title;
  String description;
  int price;
  List images;
  List sizes;
  List<ProductVariants> variants;
  Category category;
  bool available;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.images,
    this.sizes,
    this.variants,
    this.category,
    this.available,
  });

  // factory Product.fromJson(Map<String, dynamic> json) => Product(
  //       id: json['_id'],
  //       title: json['title'],
  //       description: json['description'],
  //       price: json['price'],
  //       stock: json['stock'],
  //       images: json['images'],
  //       sizes: json['sizes'],
  //       variants: (json['variants'] as List)
  //           .map((i) => ProductVariants.fromJson(i))
  //           .toList(),
  //       category: Category.fromMap(json['category']),
  //       available: json['available'],
  //     );

  Product.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    sizes = json['sizes'];
    price = json['price'];
    available = json['available'];
    if (json['variants'] != null) {
      variants = List<ProductVariants>();
      json['variants'].forEach((v) {
        variants.add(ProductVariants.fromJson(v));
      });
    }
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'price': price,
      'images': images,
      'sizes': sizes,
      'category': category,
      'variants': variants,
      'available': available,
    };
  }
}
