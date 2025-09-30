import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get isConnectedStream {
    return _connectivity.onConnectivityChanged
        .map((result) => result != ConnectivityResult.none);
  }

  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}
