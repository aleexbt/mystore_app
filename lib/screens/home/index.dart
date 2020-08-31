import 'package:flutter/material.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/screens/home/home.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      child: Navigator(
        key: NavKey.homeKey,
        onGenerateRoute: (RouteSettings settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => Home(),
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
