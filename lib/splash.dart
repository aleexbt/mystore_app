import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/helpers/user_functions.dart';
import 'package:mystore/models/network_model.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/services/api.dart';
import 'package:provider/provider.dart';
import 'controllers/user_provider.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoggedIn = false;
  String _token;
  User _userData;
  List<UserCard> _cards = [];

  @override
  void initState() {
    super.initState();
    launch();
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

  void launch() async {
    Box box = await Hive.openBox('MyStore');
    _isLoggedIn = box.get('isLoggedIn') ?? false;
    _token = box.get('token') ?? null;
    _userData = box.get('userData');
    _cards =
        _userData != null ? await UserFunctions.getCards(_userData.id) : [];
    _userData?.cards = _cards;
    launchPrefs();
  }

  void getUserData() async {
    NetworkHandler network = await Api.userInfo();
    if (!network.error) {
      _userData = User.fromJson({
        'id': network.response['_id'],
        'name': network.response['name'],
        'email': network.response['email'],
        'phone': network.response['phone'],
        'cpf': network.response['cpf'],
        'address': network.response['address'],
        'cards': _cards,
      });
      authOnlineData();
    } else {
      authOfflineData();
    }
  }

  void launchPrefs() async {
    try {
      if (_token != null && _isLoggedIn) {
        getUserData();
      } else {
        debugPrint('Usuario não autenticado');
        await Future.delayed(Duration(seconds: 2));
        Navigator.pushReplacementNamed(context, '/app');
      }
    } catch (e) {
      debugPrint('SPLASH_ERROR: $e');
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/app');
    }
  }

  void authOnlineData() async {
    Box box = await Hive.openBox('MyStore');
    // context.read<UserModel>().token = _token;
    context.read<UserModel>().setUserData(_userData);
    context.read<UserModel>().setLoggedIn = true;
    await context.read<CartModel>().loadCart();
    box.put('userData', _userData);
    Navigator.pushReplacementNamed(context, '/app');
  }

  void authOfflineData() async {
    // context.read<UserModel>().token = _token;
    context.read<UserModel>().setUserData(_userData);
    context.read<UserModel>().setLoggedIn = true;
    Navigator.pushReplacementNamed(context, '/app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
