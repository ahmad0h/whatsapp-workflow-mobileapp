import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream =>
      _connectivityController.stream;

  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  void initialize() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final hasConnection = !results.contains(ConnectivityResult.none);
      _connectivityController.add(hasConnection);
    });
  }

  void dispose() {
    _connectivityController.close();
  }
}
