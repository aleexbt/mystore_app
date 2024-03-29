import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystore/app.dart';
import 'package:mystore/screens/cart/select_address.dart';
import 'package:mystore/screens/product/eletronicos.dart';
import 'package:mystore/screens/settings/address.dart';
import 'package:mystore/screens/settings/address_editor.dart';
import 'package:mystore/screens/cart/cart.dart';
import 'package:mystore/screens/categories.dart';
import 'package:mystore/screens/category.dart';
import 'package:mystore/screens/cart/checkout.dart';
import 'package:mystore/screens/settings/change_password.dart';
import 'package:mystore/screens/settings/payment_editor.dart';
import 'package:mystore/screens/cart/finish_order.dart';
import 'package:mystore/screens/auth/login.dart';
import 'package:mystore/screens/cart/payment_methods.dart';
import 'package:mystore/screens/product/roupas.dart';
import 'package:mystore/screens/auth/register.dart';
import 'package:mystore/screens/settings/payment.dart';
import 'package:mystore/screens/settings/settings.dart';
import 'package:mystore/screens/my_orders.dart';
import 'package:mystore/screens/settings/profile.dart';
import 'package:mystore/splash.dart';
import 'package:mystore/test.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/app':
        return MaterialPageRoute(builder: (_) => App(redirectPage: args));
      case '/categories':
        return MaterialPageRoute(builder: (_) => Categories());
      case '/category':
        return MaterialPageRoute(builder: (_) => Category(args));
      case '/product/roupas':
        return MaterialPageRoute(builder: (_) => Roupas(pid: args));
      case '/product/eletronicos':
        return MaterialPageRoute(builder: (_) => Eletronicos(pid: args));
      case '/home/product':
        return CupertinoPageRoute(
            builder: (_) => Roupas(pid: args), fullscreenDialog: true);
      case '/cart':
        // return MaterialPageRoute(builder: (_) => Cart());
        return CupertinoPageRoute(
            builder: (_) => Cart(), fullscreenDialog: true);
      case '/cart/select_address':
        // return MaterialPageRoute(builder: (_) => Cart());
        return MaterialPageRoute(builder: (_) => SelectAddress());
      case '/auth/login':
        return MaterialPageRoute(builder: (_) => Login(redirectTimes: args));
      case '/auth/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/cart/checkout':
        return MaterialPageRoute(builder: (_) => Checkout());
      case '/cart/checkout/finish':
        return MaterialPageRoute(builder: (_) => FinishOrder(args));
      case '/my_orders':
        return MaterialPageRoute(builder: (_) => MyOrders());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());
      case '/settings/address':
        return CupertinoPageRoute(
          builder: (_) => Address(),
        );
      case '/settings/address/editor':
        return CupertinoPageRoute(
          builder: (_) => AddressEditor(addressData: args),
          fullscreenDialog: true,
        );
      case '/settings/payment':
        return CupertinoPageRoute(
          builder: (_) => Payment(),
        );
      case '/settings/payment/editor':
        return CupertinoPageRoute(
          builder: (_) => PaymentEditor(creditCardData: args),
          fullscreenDialog: true,
        );
      case '/settings/profile':
        return CupertinoPageRoute(
          builder: (_) => Profile(profileData: args),
        );
      case '/settings/profile/change_password':
        return CupertinoPageRoute(
          builder: (_) => ChangePassword(),
        );
      case '/payment_methods':
        return CupertinoPageRoute(
          builder: (_) => PaymentMethods(data: args),
          fullscreenDialog: false,
        );
      case '/teste':
        return MaterialPageRoute(
          builder: (_) => Teste(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Ops, não conseguimos encontrar esta página.'),
        ),
      );
    });
  }
}
