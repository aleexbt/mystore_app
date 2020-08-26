import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/datas/cart_product.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();
  List<CartProduct> products = [];
  bool isLoading = false;
  RxBool _apiLoading = false.obs;
  String _couponCode = '';
  int _discountPercentage = 0;
  int productsPrice = 0;
  int totalItems = 0;
  String _selectedShipping;
  RxInt _shippingPrice = 0.obs;
  String selectedCard;

// Checkout payment methods: 1 Credit Card, 2 Cash, 3 Debit
  bool _onlinePayment;
  int _paymentMethod;
  bool _isChangeNeeded;
  int _paymentChange;

  set setApiLoading(bool value) {
    _apiLoading.value = value;
    update();
  }

  get apiLoading => _apiLoading.value;

  set selectedShipping(String value) {
    _selectedShipping = value;
    update();
  }

  get selectedShipping => _selectedShipping;

  set setShippingPrice(int value) {
    _shippingPrice.value = value;
    update();
  }

  get shippingPrice => _shippingPrice.value;

  set onlinePayment(bool value) {
    _onlinePayment = value;
    update();
  }

  bool get onlinePayment => _onlinePayment;

  set paymentMethod(int value) {
    _paymentMethod = value;
    update();
  }

  int get paymentMethod => _paymentMethod;

  set isChangeNeeded(bool value) {
    _isChangeNeeded = value;
    update();
  }

  bool get isChangeNeeded => _isChangeNeeded;

  set paymentChange(int value) {
    _paymentChange = value;
    update();
  }

  get paymentChange => _paymentChange;

  int get productCount => products.length;

  set setCouponCode(String value) {
    _couponCode = value;
    update();
  }

  get couponCode => _couponCode;

  set setDiscountPercentage(int value) {
    _discountPercentage = value;
    update();
  }

  get discountPercentage => _discountPercentage;

  void paymentClear() {
    _onlinePayment = null;
    _paymentMethod = null;
    _paymentChange = null;
    update();
  }

  void addressClear() {
    _selectedShipping = null;
    update();
  }

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);
    update();
    _saveData();
  }

  void removeCartItem(CartProduct cartProduct) {
    products.remove(cartProduct);
    update();
    _saveData();
  }

  void decProduct(CartProduct cartProduct) {
    cartProduct.qtd--;
    update();
    _saveData();
  }

  void incProduct(CartProduct cartProduct) {
    cartProduct.qtd++;
    update();
    _saveData();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    setCouponCode = couponCode;
    setDiscountPercentage = discountPercentage;
    update();
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
    debugPrint(data);
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

  void loadCart() async {
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
      update();
      _saveData();
    } catch (err) {
      print(err);
    }
  }

  Future<String> finishOrder(BuildContext context) async {
    if (products.length == 0) return null;
    isLoading = true;
    update();
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
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/cart/checkout/finish', (Route<dynamic> route) => false,
          arguments: {'orderId': response.data['order']});
      update();
      _saveData();
      return null;
    } else {
      print(response.data['msg']);
      isLoading = false;
      update();
      return response.data['msg'];
    }
  }
}
