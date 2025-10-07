import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get isConnectedStream => _connectivity.onConnectivityChanged
        .map((result) => !result.contains(ConnectivityResult.none));

  Future<bool> get isConnected async {
    var result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
