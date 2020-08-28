import 'package:flutter/material.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/screens/categories.dart';
import 'package:mystore/screens/category.dart';
import 'package:mystore/screens/product.dart';

class ProductsNavigator extends StatefulWidget {
  @override
  _ProductsNavigatorState createState() => _ProductsNavigatorState();
}

class _ProductsNavigatorState extends State<ProductsNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      child: Navigator(
        key: NavKey.productsKey,
        onGenerateRoute: (RouteSettings settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => Categories(),
              );
            case '/category':
              return MaterialPageRoute(
                builder: (_) => Category(args),
              );
            case '/product':
              return MaterialPageRoute(
                builder: (_) => Product(args),
              );
            default:
              return _errorRoute();
          }
        },
      ),
      onWillPop: () async => !await NavKey.productsKey.currentState.maybePop(),
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
