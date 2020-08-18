import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart';

final String baseUrl = 'https://com-xelapps-mystore.herokuapp.com';

BaseOptions options = BaseOptions(
  connectTimeout: 10000,
  receiveTimeout: 3000,
);

Dio dio = Dio(options);
final _dioCacheManager = DioCacheManager(CacheConfig());
//Options _cacheOptions = buildCacheOptions(Duration(hours: 3));

class Api {
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

  static Future userInfo(String token) async {
    dio.options.headers["Authorization"] = '$token';
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
    Response response = await dio.get(baseUrl + '/categories');
    return response;
  }

  static Future productsByCategory(String id) async {
    Response response = await dio.get(baseUrl + '/categories/$id');
    return response;
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

  static Future createOrder(
      Map<String, dynamic> orderData, String token) async {
    dio.options.headers["Authorization"] = '$token';
    Response response = await dio.post(baseUrl + '/orders', data: orderData);
    return response;
  }

  static Future getOrders(String token) async {
    dio.options.headers["Authorization"] = '$token';
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

  static Future addAddress(Map<String, dynamic> userData, String token) async {
    dio.options.headers["Authorization"] = '$token';
    Response response =
        await dio.post(baseUrl + '/users/address', data: userData);
    return response;
  }

  static Future updateUser(Map<String, dynamic> userData, String token) async {
    dio.options.headers["Authorization"] = '$token';
    Response response = await dio.put(baseUrl + '/users', data: userData);
    return response;
  }

  static Future updateAddress(
      Map<String, dynamic> userData, String token) async {
    dio.options.headers["Authorization"] = '$token';
    Response response =
        await dio.put(baseUrl + '/users/address', data: userData);
    return response;
  }

  static Future removeAddress(String token, String addressId) async {
    dio.options.headers["Authorization"] = '$token';
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
