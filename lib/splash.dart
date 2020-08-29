import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/user_provider.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    //_openBox();
    launchPrefs();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   launchPrefs();
    // });
  }

  @override
  void didChangeDependencies() async {
    await precachePicture(
        SvgPicture.asset('assets/disconnected.svg').pictureProvider, context);
    super.didChangeDependencies();
  }

  void launchPrefs() async {
    try {
      final SharedPreferences prefs = await _prefs;
      Box box = await Hive.openBox('MyStore');
      String _token = box.get('token');
      bool _isLoggedIn = box.get('isLoggedIn');

      User _userData = box.get('userData');

      print(_userData.name);

      //prefs.clear();

      if (_token != null && _isLoggedIn) {
        debugPrint('Usuário autenticado');

        try {
          var response = await Api.userInfo();
          User userData = User.fromJson({
            'id': response.data['_id'],
            'name': response.data['name'],
            'email': response.data['email'],
            'phone': response.data['phone'],
            'cpf': response.data['cpf'],
            'address': response.data['address'],
            'cards': await UserFunctions.getCards(response.data['_id']),
          });

          Provider.of<UserModel>(context, listen: false).token = _token;
          Provider.of<UserModel>(context, listen: false).setUserData(userData);
          Provider.of<UserModel>(context, listen: false).setLoggedIn = true;
          await Provider.of<CartModel>(context, listen: false).loadCart();
          Navigator.pushReplacementNamed(context, '/app');
        } catch (err) {
          User _userData = box.get('userData');
          List<UserCard> _cards = await UserFunctions.getCards(_userData.id);
          _cards.length == 0
              ? _userData.cards = []
              : _cards.forEach((element) {
                  _userData.cards.add(element);
                });
          Provider.of<UserModel>(context, listen: false).token = _token;
          Provider.of<UserModel>(context, listen: false).setUserData(_userData);
          Provider.of<UserModel>(context, listen: false).setLoggedIn = true;
          Navigator.pushReplacementNamed(context, '/app');
        }
      } else {
        debugPrint('Usuario não autenticado');
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/app');
      }
    } catch (e) {
      debugPrint('OCORREU UM ERRO: $e');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/app');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kPrimaryColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 211, 110, 130),
              Color.fromARGB(255, 253, 181, 168),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'MyStore',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
