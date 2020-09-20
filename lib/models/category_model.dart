class Category {
  String id;
  String code;
  String name;
  String icon;

  Category({this.id, this.code, this.name, this.icon});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['_id'],
        code: json['code'],
        name: json['name'],
        icon: json['icon'],
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'icon': icon,
    };
  }
}
