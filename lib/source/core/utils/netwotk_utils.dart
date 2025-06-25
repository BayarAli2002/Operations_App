import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crud_app/source/core/utils/utils.dart';

class NetworkUtils {
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}



class ConnectivityHelper {
  /// Returns `true` if connected to internet. Shows toast and returns `false` if not.
  static Future<bool> ensureHasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Utils.showToast("No internet access", ToastType.error);
      return false;
    }

    final hasInternet = await NetworkUtils.hasInternet();
    if (!hasInternet) {
      Utils.showToast("No internet access", ToastType.error);
      return false;
    }

    return true;
  }
}
