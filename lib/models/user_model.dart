import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserAddress {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool primary;
  @HiveField(2)
  String name;
  @HiveField(3)
  String state;
  @HiveField(4)
  String city;
  @HiveField(5)
  String neighborhood;
  @HiveField(6)
  String street;
  @HiveField(7)
  String streetNumber;
  @HiveField(8)
  String complement;
  @HiveField(9)
  String reference;
  @HiveField(10)
  String zipcode;

  UserAddress(
      {this.id,
      this.primary,
      this.name,
      this.state,
      this.city,
      this.neighborhood,
      this.street,
      this.streetNumber,
      this.complement,
      this.reference,
      this.zipcode});

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        id: json['_id'],
        primary: json['primary'],
        name: json['name'],
        state: json['state'],
        city: json['city'],
        neighborhood: json['neighborhood'],
        street: json['street'],
        streetNumber: json['street_number'],
        complement: json['complement'],
        reference: json['reference'],
        zipcode: json['zipcode'],
      );

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'primary': primary,
      'name': name,
      'state': state,
      'city': city,
      'neighborhood': neighborhood,
      'street': street,
      'streetNumber': streetNumber,
      'complement': complement,
      'reference': reference,
      'zipcode': zipcode,
    };
  }
}

class UserCard {
  String id;
  String brand;
  String number;
  String name;
  String expiration;
  String cvv;
  String cpf;
  UserAddress billing;

  UserCard({
    this.id,
    this.brand,
    this.number,
    this.name,
    this.expiration,
    this.cvv,
    this.cpf,
    this.billing,
  });

  factory UserCard.fromJson(Map<String, dynamic> json) => UserCard(
        id: json['id'],
        brand: json['brand'],
        number: json['number'],
        name: json['name'],
        expiration: json['expiration'],
        cvv: json['cvv'],
        cpf: json['cpf'],
        billing: json['billing'] != null
            ? UserAddress.fromJson(json['billing'])
            : null,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'number': number,
      'name': name,
      'expiration': expiration,
      'cvv': cvv,
      'cpf': cpf,
      'billing': billing,
    };
  }
}

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String cpf;
  @HiveField(5)
  List<UserAddress> address;
  List<UserCard> cards;

  User(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.cards,
      this.phone,
      this.cpf});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        cpf: json['cpf'],
        address: (json['address'] as List)
            .map((i) => UserAddress.fromJson(i))
            .toList(),
        cards:
            (json['cards'] as List).map((i) => UserCard.fromJson(i)).toList(),
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'cards': cards,
    };
  }
}
