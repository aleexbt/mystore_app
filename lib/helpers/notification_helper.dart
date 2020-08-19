import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import './navigation_helper.dart';

class NotificationHelper {
  final navigatorKey = NavKey.navKey;

  void initOneSignal({userId}) async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      debugPrint("NOTIFICATION_RECEIVED");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      var notifyDetails = result.notification.payload.additionalData;
      debugPrint("NOTIFICATION_CLICKED");
      if (notifyDetails["page"] == "orders") {
        navigatorKey.currentState
            .pushNamedAndRemoveUntil('/app', (route) => false, arguments: 2);
      } else {
        debugPrint("NOTIFICATION_BYPASS");
      }
    });

    await OneSignal.shared
        .init("3762e09d-184a-42ad-8254-05c58a3c5eec", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    if (userId != null) {
      OneSignal.shared.setExternalUserId(userId);
    }
  }
}
