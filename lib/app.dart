import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/notification_helper.dart';
import 'package:mystore/screens/auth/login.dart';
import 'package:mystore/screens/home.dart';
import 'package:mystore/screens/categories.dart';
//import 'package:mystore/screens/places_screen.dart';
import 'package:mystore/screens/settings/settings.dart';
import 'package:mystore/screens/my_orders.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final redirectPage;

  const App({Key key, this.redirectPage}) : super(key: key);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    String userId = Provider.of<UserModel>(context).userData?.id ?? null;
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
          Categories(),
          // Places(),
          MyOrders(),
          model.isLoggedIn ? Settings() : Login(),
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
            title: Text('Categorias'),
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
            icon: Icon(Icons.account_circle),
            title: Text('Perfil'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) => _pageController.animateToPage(index,
            duration: Duration(milliseconds: 200), curve: Curves.linear),
      ),
    );
  }
}
