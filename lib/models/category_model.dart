class Category {
  String id;
  String name;
  String icon;

  Category({this.id, this.name, this.icon});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{'id': id, 'name': name, 'icon': icon};
    return map;
  }

  Category.fromMap(Map<String, dynamic> map) {
    id = map['_id'];
    name = map['name'];
    icon = map['icon'];
  }
}
