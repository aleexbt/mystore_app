import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/helpers/notification_helper.dart';
import 'package:mystore/screens/auth/login.dart';
import 'package:mystore/screens/cart/index.dart';
import 'package:mystore/screens/home.dart';
import 'package:mystore/screens/settings/index.dart';
import 'package:mystore/screens/my_orders.dart';
import 'package:mystore/screens/products_navigator.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final redirectPage;

  const App({Key key, this.redirectPage}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  PageController _pageController = NavKey.pageController;
  int _selectedIndex = 0;
  int productCount = 0;

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void redirect(int page) {
    setState(() {
      _selectedIndex = page;
    });
    _pageController = PageController(initialPage: page);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // statusBarIconBrightness: Brightness.dark,
    ));
    if (widget.redirectPage != null) {
      redirect(widget.redirectPage);
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    String userId =
        Provider.of<UserModel>(context, listen: false).userData?.id ?? null;
    NotificationHelper().initOneSignal(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<UserModel>(context);
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: <Widget>[
          Home(),
          ProductsNavigator(),
          // Places(),
          MyOrders(),
          CartNavigator(),
          model.isLoggedIn ? SettingsNavigator() : Login(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        backgroundColor: kPrimaryColor,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        unselectedItemColor: Colors.grey,
        selectedItemColor: kPrimaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Início'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Produtos'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.store),
          //   title: Text('Lojas'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.trayFull),
            title: Text('Pedidos'),
          ),
          BottomNavigationBarItem(
            icon: context.watch<CartModel>().productCount == 0
                ? Icon(Icons.shopping_cart)
                : Badge(
                    badgeContent: Text(
                      context.watch<CartModel>().productCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    child: Icon(Icons.shopping_cart),
                  ),
            title: Text('Carrinho'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Sua Conta'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) => _pageController.animateToPage(index,
            duration: Duration(milliseconds: 200), curve: Curves.linear),
      ),
    );
  }
}
