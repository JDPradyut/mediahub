import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';

class AdMobServices {
  static String get bannerAdUnitID => Platform.isAndroid
      ? 'ca-app-pub-4365365728148175/7093596547'
      : 'ca-app-pub-4365365728148175/7093596547';

  static void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        print('loaded');
        break;
      case AdmobAdEvent.opened:
        print('opened');
        break;
      case AdmobAdEvent.closed:
        print('closed');
        break;
      case AdmobAdEvent.failedToLoad:
        print('Failed');
        break;
      case AdmobAdEvent.rewarded:
        print('Done');
        break;
      default:
    }
  }
}
