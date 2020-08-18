import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool _isLoggedIn = false;
  bool isLoading = false;
  String token = '';
  User _userData;

  void setUserData(User userData) {
    _userData = userData;
    notifyListeners();
  }

  void addCard(UserCard card) {
    _userData.cards.add(card);
    notifyListeners();
  }

  void editCard(UserCard card) {
    UserCard edit =
        _userData.cards.firstWhere((item) => item.id == card.id, orElse: null);

    if (edit != null) {
      edit.number = card.number;
      edit.name = card.name;
      edit.expiration = card.expiration;
      edit.cvv = card.cvv;
      edit.cpf = card.cpf;
      edit.billing = card.billing;
      notifyListeners();
    }
  }

  void addAddress(UserAddress address) {
    _userData.address.add(address);
    notifyListeners();
  }

  void editAddress(UserAddress address) {
    UserAddress edit = _userData.address
        .firstWhere((item) => item.id == address.id, orElse: null);

    if (edit != null) {
      edit.name = address.name;
      edit.zipcode = address.zipcode;
      edit.street = address.street;
      edit.streetNumber = address.streetNumber;
      edit.complement = address.complement;
      edit.reference = address.reference;
      edit.neighborhood = address.neighborhood;
      edit.city = address.city;
      edit.state = address.state;
      notifyListeners();
    }
  }

  void removeAddress(UserAddress address) {
    _userData.address.removeWhere((item) => item.id == address.id);
    notifyListeners();
  }

  void removeCard(UserCard card) async {
    _userData.cards.removeWhere((item) => item.id == card.id);
    final storage = FlutterSecureStorage();
    final SharedPreferences prefs = await _prefs;
    final String _oldCardKey = card.number.substring(card.number.length - 4);

    List<String> cardKeys = prefs.getStringList('${userData.id}_cards');
    cardKeys.removeWhere((item) => item == _oldCardKey);
    prefs.setStringList('${userData.id}_cards', cardKeys);
    await storage.delete(key: _oldCardKey);
    notifyListeners();
  }

  void updateUser(Map<String, dynamic> user) {
    userData.name = user['name'];
    userData.email = user['email'];
    userData.phone = user['phone'];
    userData.cpf = user['cpf'];
    notifyListeners();
  }

  set setLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  bool get isLoggedIn => _isLoggedIn;
  User get userData => _userData;

  Future<dynamic> signUp({
    String name,
    String email,
    String password,
  }) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> userData = {
      'name': name,
      'email': email,
      'password': password,
    };

    var response = await Api.signUp(userData);

    if (response.data['success']) {
      signIn(email: email, password: password);
      return null;
    } else {
      isLoading = false;
      notifyListeners();
      return response.data['errors'];
    }
  }

  Future<String> signIn(
      {@required String email, @required String password}) async {
    isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await _prefs;
    Map<String, dynamic> userData = {'email': email, 'password': password};

    var response = await Api.signIn(userData);

    if (response.data['success']) {
      List _cards =
          await UserFunctions.getCards(response.data['payload']['id']);
      User userData = User.fromJson({
        'id': response.data['payload']['id'],
        'name': response.data['payload']['name'],
        'email': response.data['payload']['email'],
        'phone': response.data['payload']['phone'] ?? null,
        'cpf': response.data['payload']['cpf'] ?? null,
        'address': response.data['payload']['address'],
        'cards': _cards,
      });
      setUserData(userData);
      setLoggedIn = true;
      token = response.data['token'];
      prefs.setString('token', response.data['token']);
      prefs.setBool('isLoggedIn', true);
      isLoading = false;
      notifyListeners();
      return null;
    } else {
      isLoading = false;
      notifyListeners();
      return response.data['msg'];
    }
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/cart.json');
  }

  logOut(BuildContext context) async {
    final SharedPreferences prefs = await _prefs;
    var file = await _getFile();
    file.writeAsString('');
    setLoggedIn = false;
    setUserData(null);
    Provider.of<CartModel>(context, listen: false).products = [];
    prefs.setBool('isLoggedIn', false);
    prefs.setBool('token', null);
  }
}
