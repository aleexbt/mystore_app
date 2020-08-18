class CreditCardDetails {
  String number;
  String name;
  String validity;
  String code;
  String cpf;

  CreditCardDetails(
      {this.number, this.name, this.validity, this.code, this.cpf});

  factory CreditCardDetails.fromJson(Map<String, String> json) =>
      CreditCardDetails(
        number: json['number'],
        name: json['name'],
        validity: json['validity'],
        code: json['code'],
        cpf: json['cpf'],
      );

  Map<String, String> toJson() {
    return {
      'number': number,
      'name': name,
      'validity': validity,
      'code': code,
      'cpf': cpf,
    };
  }
}

class CreditCard {
  String key;
  String brand;
  Map<String, String> details;

  CreditCard({this.key, this.brand, this.details});

  factory CreditCard.fromJson(Map<String, String> json) => CreditCard(
        key: json['key'],
        brand: json['brand'],
      );
}
