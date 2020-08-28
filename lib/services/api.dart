import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
final _storage = FlutterSecureStorage();

final String baseUrl = isProduction
    ? 'https://xelapps-mystore.herokuapp.com'
    : 'http://192.168.0.10:3000';

BaseOptions options = BaseOptions(
  connectTimeout: 20000,
  receiveTimeout: 3000,
);

Dio dio = Dio(options);
final _dioCacheManager = DioCacheManager(CacheConfig());
//Options _cacheOptions = buildCacheOptions(Duration(hours: 3));

class Api {
  static Future<String> getToken() async {
    try {
      final SharedPreferences prefs = await _prefs;
      Map<String, dynamic> payload = Jwt.parseJwt(prefs.get('token'));
      Future<String> secureToken = _storage.read(key: 'secure_token');
      String _secureToken = await secureToken;
      int currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String _token = prefs.get('token');

      if (payload['exp'] < currentTime) {
        dio.options.headers["Authorization"] = '$_token';
        dio.options.headers["token"] = '$_secureToken';
        Response response = await dio.post(baseUrl + '/token');
        if (response.data['success']) {
          debugPrint('REFRESH_TOKEN_SUCCESS');
          prefs.setString('token', response.data['token']);
          _token = response.data['token'];
        } else {
          debugPrint('REFRESH_TOKEN_FAIL');
        }
      }
      return _token;
    } catch (err) {
      return null;
    }
  }

  static Future appConfig() async {
    dio.interceptors.add(_dioCacheManager.interceptor);
    try {
      Response response = await dio.get(baseUrl + '/config');
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        return null;
      } else {
        debugPrint(e.request.toString());
        debugPrint(e.message);
        return null;
      }
    }
  }

  static Future userInfo() async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response = await dio.get(baseUrl + '/users/me');
    return response;
  }

  static Future signUp(Map<String, dynamic> userData) async {
    Response response = await dio.post(baseUrl + '/users', data: userData);
    return response;
  }

  static Future signIn(Map<String, dynamic> userData) async {
    Response response = await dio.post(baseUrl + '/session', data: userData);
    return response;
  }

  static Future getCategories() async {
    dio.interceptors.add(_dioCacheManager.interceptor);
    try {
      Response response = await dio.get(baseUrl + '/categories');
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        return null;
      } else {
        debugPrint(e.request.toString());
        debugPrint(e.message);
        return null;
      }
    }
  }

  static Future productsByCategory(String id) async {
    try {
      Response response = await dio.get(baseUrl + '/categories/$id');
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        return null;
      } else {
        debugPrint(e.request.toString());
        debugPrint(e.message);
        return null;
      }
    }
  }

  static Future productById(String id) async {
    Response<Map<String, dynamic>> response =
        await dio.get(baseUrl + '/products/$id');
    return response.data;
  }

  static Future checkCoupon(String coupon) async {
    Response response =
        await dio.post(baseUrl + '/coupon', data: {'coupon': '$coupon'});
    return response;
  }

  static Future createOrder(Map<String, dynamic> orderData) async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response = await dio.post(baseUrl + '/orders', data: orderData);
    return response;
  }

  static Future getOrders() async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response = await dio.get(baseUrl + '/orders');
    return response.data;
  }

  static Future validateCep(String cep) async {
    Response response = await dio.get(baseUrl + '/services/cep/$cep');
    return response;
  }

  static Future calculateShipping(String cep) async {
    Response response = await dio.get(baseUrl + '/services/frete/$cep');
    return response.data;
  }

  static Future addAddress(Map<String, dynamic> userData) async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response =
        await dio.post(baseUrl + '/users/address', data: userData);
    return response;
  }

  static Future updateUser(Map<String, dynamic> userData) async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response = await dio.put(baseUrl + '/users', data: userData);
    return response;
  }

  static Future updateAddress(Map<String, dynamic> userData) async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response =
        await dio.put(baseUrl + '/users/address', data: userData);
    return response;
  }

  static Future removeAddress(String addressId) async {
    String _token = await getToken();
    dio.options.headers["Authorization"] = '$_token';
    Response response = await dio.delete(baseUrl + '/users/address/$addressId');
    return response;
  }

  static Future getCartProductsInfo(List<String> products) async {
    Response response = await dio.post(
      baseUrl + "/cart",
      data: {'products': products},
    );
    return response;
  }
}
