import 'category_model.dart';

class ProductVariantsOptions {
  String label;
  String value;
  int qtd;

  ProductVariantsOptions({
    this.label,
    this.value,
    this.qtd,
  });

  factory ProductVariantsOptions.fromJson(Map<String, dynamic> json) =>
      ProductVariantsOptions(
        label: json['label'],
        value: json['value'],
        qtd: json['qtd'],
      );
}

class ProductVariants {
  String id;
  String size;
  String color;
  int qtd;

  ProductVariants({
    this.id,
    this.size,
    this.color,
    this.qtd,
  });

  factory ProductVariants.fromJson(Map<String, dynamic> json) =>
      ProductVariants(
        id: json['_id'],
        size: json['size'],
        color: json['color'],
        qtd: json['qtd'],
      );
}

class Product {
  String id;
  String title;
  String description;
  int price;
  int stock;
  List images;
  List sizes;
  List<ProductVariants> variants;
  List availableSizes;
  List availableColors;
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
    this.availableSizes,
    this.availableColors,
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
    stock = json['stock'];
    available = json['available'];
    if (json['variants'] != null) {
      variants = List<ProductVariants>();
      json['variants'].forEach((v) {
        variants.add(ProductVariants.fromJson(v));
      });
    }
    availableSizes = json['availableSizes'];
    availableColors = json['availableColors'];
    category =
        json['category'] != null ? Category.fromMap(json['category']) : null;
  }

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
      'availableSizes': availableSizes,
      'availableColors': availableColors,
      'available': available,
    };
  }
}
