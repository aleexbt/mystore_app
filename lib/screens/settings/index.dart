import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystore/helpers/navigation_helper.dart';
import 'package:mystore/screens/settings/address.dart';
import 'package:mystore/screens/settings/address_editor.dart';
import 'package:mystore/screens/settings/change_password.dart';
import 'package:mystore/screens/settings/payment.dart';
import 'package:mystore/screens/settings/payment_editor.dart';
import 'package:mystore/screens/settings/profile.dart';
import 'package:mystore/screens/settings/settings.dart';

import 'package:page_transition/page_transition.dart';

class SettingsNavigator extends StatefulWidget {
  @override
  _SettingsNavigatorState createState() => _SettingsNavigatorState();
}

class _SettingsNavigatorState extends State<SettingsNavigator>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      child: Navigator(
        key: NavKey.settingsKey,
        onGenerateRoute: (RouteSettings settings) {
          final args = settings.arguments;
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                builder: (_) => Settings(),
              );
            case '/settings/profile':
              return CupertinoPageRoute(
                builder: (_) => Profile(profileData: args),
              );
            // return PageTransition(
            //     child: Profile(profileData: args),
            //     type: PageTransitionType.rightToLeft);
            case '/settings/profile/change_password':
              return CupertinoPageRoute(
                builder: (_) => ChangePassword(),
              );
            case '/settings/address':
              return CupertinoPageRoute(
                builder: (_) => Address(),
              );
            case '/settings/address/editor':
              return CupertinoPageRoute(
                builder: (_) => AddressEditor(addressData: args),
                fullscreenDialog: true,
              );
            case '/settings/payment':
              return CupertinoPageRoute(
                builder: (_) => Payment(),
              );
            case '/settings/payment/editor':
              return CupertinoPageRoute(
                builder: (_) => PaymentEditor(creditCardData: args),
                fullscreenDialog: true,
              );
            default:
              return _errorRoute();
          }
        },
      ),
      onWillPop: () async => !await NavKey.settingsKey.currentState.maybePop(),
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
