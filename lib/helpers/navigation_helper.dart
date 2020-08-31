import 'package:flutter/material.dart';

class NavKey {
  static final navKey = GlobalKey<NavigatorState>();
  static final homeKey = GlobalKey<NavigatorState>();
  static final productsKey = GlobalKey<NavigatorState>();
  static final settingsKey = GlobalKey<NavigatorState>();
  static final cartKey = GlobalKey<NavigatorState>();
  static var pageController = PageController();
}
