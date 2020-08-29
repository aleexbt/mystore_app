import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/controllers/cart_provider.dart';
import 'package:mystore/controllers/global.dart';
import 'package:mystore/controllers/user_provider.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/models/user_model.dart';
import 'package:mystore/routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const bool isProduction = bool.fromEnvironment('dart.vm.product');
Future<void> main() async {
  if (isProduction) {
    debugPrint = (String message, {int wrapWidth}) {};
  }
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserAddressAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Global()),
        ChangeNotifierProvider(create: (context) => UserModel()),
        ChangeNotifierProvider(create: (context) => CartModel())
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('pt', 'BR'),
            const Locale('pt', 'PT'),
            const Locale('en', 'US'),
          ],
          debugShowCheckedModeBanner: false,
          title: 'MyStore',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0.5,
                color: kPrimaryColor,
                iconTheme: IconThemeData(
                  color: Colors.white,
                ),
                textTheme: TextTheme(
                  headline6: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                )),
            //primaryColor: Color.fromARGB(255, 211, 110, 130),
            primaryColor: Colors.grey[50],
            accentColor: Color.fromARGB(255, 211, 110, 130),
            textSelectionHandleColor: kPrimaryColor,
            toggleableActiveColor: kPrimaryColor,
            cursorColor: Colors.grey[500],
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'SulSans',
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            // primaryColor: Color.fromARGB(255, 211, 110, 130),
            accentColor: Color.fromARGB(255, 211, 110, 130),
            textSelectionHandleColor: kPrimaryColor,
            toggleableActiveColor: kPrimaryColor,
            cursorColor: Colors.white,
            accentIconTheme: IconThemeData(color: Colors.white),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: ThemeData.dark().textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          themeMode: ThemeMode.light,
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute,
          navigatorKey: NavKey.navKey,
        ),
      ),
    );
  }
}
