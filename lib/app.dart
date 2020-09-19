import 'package:animations/animations.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/helpers/notification_helper.dart';
import 'package:mystore/screens/auth/login.dart';
import 'package:mystore/screens/cart/cart.dart';
import 'package:mystore/screens//home/home.dart';
import 'package:mystore/screens/settings/index.dart';
import 'package:mystore/screens/my_orders.dart';
import 'package:mystore/screens/products_navigator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  final currency = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

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
      statusBarIconBrightness: Brightness.dark,
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
    int prices = context.watch<CartModel>().getProductsPrice();
    int discount = context.watch<CartModel>().getDiscount();
    int ship = context.watch<CartModel>().shippingPrice;
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
          // CartNavigator(),
          model.isLoggedIn ? SettingsNavigator() : Login(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Dismissible(
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 22.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Limpar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 22.0,
                    ),
                    SizedBox(width: 10.0),
                    Text(
                      'Limpar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            direction: DismissDirection.horizontal,
            key: UniqueKey(),
            onDismissed: (_) {
              context.read<CartModel>().clearCart();
            },
            child: OpenContainer(
              transitionType: ContainerTransitionType.fade,
              openBuilder: (context, openContainer) => Cart(),
              closedColor: kPrimaryColor,
              closedShape: const ContinuousRectangleBorder(),
              openShape: const ContinuousRectangleBorder(),
              closedBuilder: (context, openContainer) {
                return context.watch<CartModel>().productCount > 0
                    ? Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                        child: SizedBox(
                          height: 39.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Badge(
                                badgeColor: Colors.white,
                                badgeContent: Text(
                                  context
                                      .watch<CartModel>()
                                      .productCount
                                      .toString(),
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontSize: 10.0,
                                  ),
                                ),
                                child: Icon(
                                  AntDesign.shoppingcart,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Ver carrinho',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${currency.format((prices + ship - discount) / 100)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ),
          BottomNavigationBar(
            elevation: 5,
            unselectedFontSize: 10,
            selectedFontSize: 10,
            unselectedItemColor: Colors.grey[500],
            selectedItemColor: Colors.grey[800],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(AntDesign.home),
                // label: 'Início',
                title: Text('Início'),
              ),
              BottomNavigationBarItem(
                icon: Icon(AntDesign.appstore_o),
                // label: 'Produtos',
                title: Text('Produtos'),
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.store),
              //   title: Text('Lojas'),
              // ),
              BottomNavigationBarItem(
                icon: Icon(Feather.file_text),
                // label: 'Pedidos',
                title: Text('Pedidos'),
              ),
              // BottomNavigationBarItem(
              //   icon: context.watch<CartModel>().productCount == 0
              //       ? Icon(AntDesign.shoppingcart)
              //       : Badge(
              //           badgeColor: kPrimaryColor,
              //           badgeContent: Text(
              //             context.watch<CartModel>().productCount.toString(),
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 10.0,
              //             ),
              //           ),
              //           child: Icon(AntDesign.shoppingcart),
              //         ),
              //   title: Text('Carrinho'),
              // ),
              BottomNavigationBarItem(
                icon: Icon(AntDesign.user),
                // label: 'Sua Conta',
                title: Text('Sua Conta'),
              )
            ],
            currentIndex: _selectedIndex,
            // onTap: (int index) => _pageController.animateToPage(index,
            //     duration: Duration(milliseconds: 200), curve: Curves.linear),
            onTap: (int index) => _pageController.jumpToPage(index),
          ),
        ],
      ),
    );
  }
}
