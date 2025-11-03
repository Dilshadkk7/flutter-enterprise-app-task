import 'package:connectivity_plus/connectivity_plus.dart';

// Abstract contract for checking network status
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// Implementation that uses the connectivity_plus plugin
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    // Check if the result is either mobile or wifi
    return result == ConnectivityResult.mobile || result == ConnectivityResult.wifi;
  }
}
