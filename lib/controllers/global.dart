import 'package:flutter/foundation.dart';

class Global extends ChangeNotifier {
  bool _showBottomBar = true;
  bool _networkError = false;

  set setBottomBar(bool value) {
    _showBottomBar = value;
    notifyListeners();
  }

  get showBottomBar => _showBottomBar;

  set setNetworkError(bool value) {
    _networkError = value;
    notifyListeners();
  }

  get networkError => _networkError;

  void unhide() {
    _showBottomBar = true;
    notifyListeners();
  }
}
