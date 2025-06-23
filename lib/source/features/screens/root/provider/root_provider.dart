import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';

class RootProvider extends ChangeNotifier {
  bool _isOnline = true;
  bool get isOnline => _isOnline;

  late final StreamSubscription<ConnectivityResult> _subscription;

  RootProvider() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      // checkConnectivity now returns List<ConnectivityResult>
      final results = await Connectivity().checkConnectivity();
      _updateStatus(results.first);

      // onConnectivityChanged is Stream<List<ConnectivityResult>>
      _subscription = Connectivity().onConnectivityChanged
          .map((list) => list.first) // take the “primary” interface
          .listen(_updateStatus);
    } catch (e) {
      log('Error initializing connectivity: $e');
    }
  }

  void _updateStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      _isOnline = false;
    } else {
      _isOnline = true;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
