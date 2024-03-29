import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mystore/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFunctions {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final storage = FlutterSecureStorage();

  static Future<List> getCards(String userId) async {
    List<UserCard> _cards = [];
    try {
      final SharedPreferences prefs = await _prefs;
      List<String> _userCards = prefs.getStringList('${userId}_cards') ?? [];

      for (var card in _userCards) {
        String getCard = await storage.read(key: card);
        Map<String, dynamic> _card = json.decode(getCard);
        _cards.add(UserCard.fromJson(_card));
      }
    } catch (e) {
      debugPrint('Erro ao recuperar chaves: $e');
    }
    return _cards;
  }

  static cepFormatter(String cep) {
    return cep.replaceAllMapped(
        RegExp(r'(\d{5})(\d{3})'), (Match m) => "${m[1]}-${m[2]}");
  }

  static ccFormatter(String number) {
    return number.replaceAllMapped(RegExp(r'(\d{4})(\d{4})(\d{4})(\d{4})'),
        (Match m) => "${m[1]} ${m[2]} ${m[3]} ${m[4]}");
  }

  static ccExpirationFormatter(String number) {
    return number.replaceAllMapped(
        RegExp(r'(\d{2})(\d{2})'), (Match m) => "${m[1]}/${m[2]}");
  }
}
