import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/screens/cart/cart.dart';
import 'package:mystore/screens/cart/checkout.dart';
import 'package:mystore/screens/cart/finish_order.dart';
import 'package:mystore/screens/cart/payment_methods.dart';
import 'package:mystore/screens/cart/select_address.dart';
import 'package:mystore/screens/settings/address_editor.dart';
import 'package:mystore/screens/settings/payment_editor.dart';

class CartNavigator extends StatefulWidget {
  @override
  _CartNavigatorState createState() => _CartNavigatorState();
}

class _CartNavigatorState extends State<CartNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      child: Navigator(
        key: NavKey.cartKey,
        onGenerateRoute: (RouteSettings settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => Cart(),
              );
            case '/payment_methods':
              return CupertinoPageRoute(
                builder: (_) => PaymentMethods(data: args),
                fullscreenDialog: false,
              );
            case '/select_address':
              return CupertinoPageRoute(
                builder: (_) => SelectAddress(),
                fullscreenDialog: false,
              );
            case '/checkout':
              return MaterialPageRoute(
                builder: (_) => Checkout(),
              );
            case '/checkout/finish':
              return MaterialPageRoute(
                builder: (_) => FinishOrder(args),
              );
            case '/settings/payment/editor':
              return CupertinoPageRoute(
                builder: (_) => PaymentEditor(creditCardData: args),
                fullscreenDialog: true,
              );
            case '/settings/address/editor':
              return CupertinoPageRoute(
                builder: (_) => AddressEditor(addressData: args),
                fullscreenDialog: true,
              );
            default:
              return _errorRoute();
          }
        },
      ),
      onWillPop: () async => !await NavKey.cartKey.currentState.maybePop(),
    );
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
