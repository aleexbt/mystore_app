import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CartModel extends ChangeNotifier {
  List<CartProduct> products = [];
  bool isLoading = false;
  bool _apiLoading = false;
  String _couponCode = '';
  int _discountPercentage = 0;
  int productsPrice = 0;
  int totalItems = 0;
  String _selectedShipping;
  int _shippingPrice = 0;
  bool _shippingCalcError = false;
  String selectedCard;

// Checkout payment methods: 1 Credit Card, 2 Cash, 3 Debit
  bool _onlinePayment;
  int _paymentMethod;
  bool _isChangeNeeded;
  int _paymentChange;

  set setApiLoading(bool value) {
    _apiLoading = value;
    notifyListeners();
  }

  get apiLoading => _apiLoading;

  set selectedShipping(String value) {
    _selectedShipping = value;
    notifyListeners();
  }

  get selectedShipping => _selectedShipping;

  set setShippingPrice(int value) {
    _shippingPrice = value;
    notifyListeners();
  }

  get shippingPrice => _shippingPrice;

  set setShippingCalcError(bool value) {
    _shippingCalcError = value;
    notifyListeners();
  }

  get shippingCalcError => _shippingCalcError;

  set onlinePayment(bool value) {
    _onlinePayment = value;
    notifyListeners();
  }

  bool get onlinePayment => _onlinePayment;

  set paymentMethod(int value) {
    _paymentMethod = value;
    notifyListeners();
  }

  int get paymentMethod => _paymentMethod;

  set isChangeNeeded(bool value) {
    _isChangeNeeded = value;
    notifyListeners();
  }

  bool get isChangeNeeded => _isChangeNeeded;

  set paymentChange(int value) {
    _paymentChange = value;
    notifyListeners();
  }

  get paymentChange => _paymentChange;

  int get productCount => products.length;

  set setCouponCode(String value) {
    _couponCode = value;
    notifyListeners();
  }

  get couponCode => _couponCode;

  set setDiscountPercentage(int value) {
    _discountPercentage = value;
    notifyListeners();
  }

  get discountPercentage => _discountPercentage;

  void paymentClear() {
    _onlinePayment = null;
    _paymentMethod = null;
    _paymentChange = null;
    notifyListeners();
  }

  void addressClear() {
    _selectedShipping = null;
    notifyListeners();
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    notifyListeners();
    _saveData();
  }

  void removeCartItem(CartProduct cartProduct) {
    products.remove(cartProduct);
    notifyListeners();
    _saveData();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.qtd--;
    notifyListeners();
    _saveData();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.qtd++;
    notifyListeners();
    _saveData();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    setCouponCode = couponCode;
    setDiscountPercentage = discountPercentage;
    notifyListeners();
  }

  int getProductsPrice() {
    int price = 0;
    for (CartProduct c in products) {
      price += c.qtd * c.price;
    }
    return price;
  }

  int getDiscount() {
    return getProductsPrice() * discountPercentage ~/ 100;
  }

  int getShipPrice() {
    return 999;
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cart.json');
  }

  Future<File> _saveData() async {
    var data = json.encode(products.map((e) => e.toJson()).toList());
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<void> loadCart() async {
    try {
      var data = await _readData();
      List<String> productIds = [];
      Iterable dataJson = json.decode(data);
      List productList = dataJson;
      dataJson.forEach((item) => productIds.add(item['productId']));
      var productInfo = await Api.getCartProductsInfo(productIds);

      for (var i = 0; i < productInfo.data.length; i++) {
        if (productList[i]['productId'] == productInfo.data[i]['_id']) {
          productList[i]['price'] = productInfo.data[i]['price'];
        }
      }

      for (Map item in productList) {
        products.add(CartProduct.fromJson(item));
      }
      notifyListeners();
      _saveData();
    } catch (err) {
      print(err);
    }
  }

  Future<Map<String, dynamic>> finishOrder(BuildContext context) async {
    if (products.length == 0) return null;
    isLoading = true;
    notifyListeners();
    int productsPrice = getProductsPrice();
    int shipPrice = getShipPrice();

    UserCard card = selectedCard != null
        ? Provider.of<UserModel>(context, listen: false)
            .userData
            .cards
            .firstWhere((item) => item.id == selectedCard, orElse: null)
        : null;
    var cardDetails = {
      'name': card?.name ?? null,
      'number': card?.number ?? null,
      'expiration': card?.expiration ?? null,
      'cvv': card?.cvv ?? null,
      'cpf': card?.cpf ?? null,
    };

    Map<String, dynamic> orderData = {
      'products': products.map((cartProduct) => cartProduct.toJson()).toList(),
      'shipPrice': shipPrice,
      'discountCode': couponCode,
      'total': productsPrice,
      'shipping': selectedShipping,
      'paymentMethod': paymentMethod,
      'paymentChange': paymentChange,
      'cardDetails': card != null ? cardDetails : null,
    };

    var response = await Api.createOrder(orderData);
    if (response.data['success']) {
      // await NavKey.navKey.currentState.pushNamedAndRemoveUntil(
      //     'FinishOrder', ModalRoute.withName('App'),
      //     arguments: {'orderId': response.data['order']});

      // await NavKey.navKey.currentState.pushReplacementNamed(
      //     '/cart/checkout/finish',
      //     arguments: {'orderId': response.data['order']});
      isLoading = false;
      products = [];
      setCouponCode = '';
      setDiscountPercentage = 0;
      _selectedShipping = null;
      _paymentMethod = null;
      _paymentChange = 0;
      notifyListeners();
      _saveData();
      return {'success': true, 'orderId': response.data['order']};
    } else {
      // print(response.data['msg']);
      isLoading = false;
      notifyListeners();
      return {'success': false, 'msg': response.data['msg']};
    }
  }
}
