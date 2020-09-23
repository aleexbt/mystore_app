import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
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
              centerTitle: true,
              elevation: 0.5,
              color: Colors.white,
              iconTheme: IconThemeData(
                color: kPrimaryColor,
              ),
              textTheme: TextTheme(
                headline6: TextStyle(
                  // fontFamily: 'SulSans',
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            // fontFamily: 'SulSans',
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: kPrimaryColor,
            accentColor: kPrimaryColor,
            textSelectionHandleColor: kPrimaryColor,
            primarySwatch: Colors.grey,
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: FadeThroughPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            appBarTheme: AppBarTheme(
              elevation: 0.0,
              color: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              textTheme: TextTheme(
                headline6: TextStyle(
                  // fontFamily: 'SulSans',
                  color: Colors.black,
                  fontSize: 22.0,
                ),
              ),
            ),
            // fontFamily: 'SulSans',
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.white,
            accentColor: kPrimaryColor,
            textSelectionHandleColor: kPrimaryColor,
            hintColor: Colors.grey[600],
            cardTheme: CardTheme(
              color: Colors.white,
            ),
            iconTheme: ThemeData.light().iconTheme.copyWith(
                  color: Colors.grey[700],
                ),
            textTheme: ThemeData.dark().textTheme.copyWith(
                  bodyText1: TextStyle(color: Colors.black),
                  bodyText2: TextStyle(color: Colors.black),
                ),
            dividerColor: Colors.grey[400],
            buttonTheme: ThemeData.light().buttonTheme.copyWith(
                  disabledColor: Colors.grey[400],
                ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
            ),
            bottomSheetTheme: ThemeData.light().bottomSheetTheme.copyWith(
                  backgroundColor: Colors.white,
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
