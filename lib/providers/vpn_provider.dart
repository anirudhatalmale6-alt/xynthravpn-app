import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/server_model.dart';

enum ConnectionState { disconnected, connecting, connected, disconnecting }

class VpnProvider extends ChangeNotifier {
  ConnectionState _connectionState = ConnectionState.disconnected;
  VpnServer? _selectedServer;
  final List<VpnServer> _servers = VpnServer.defaultServers;
  DateTime? _connectedSince;
  Timer? _statsTimer;

  // Simulated traffic stats
  double _dataUp = 0;
  double _dataDown = 0;

  // Settings
  bool _autoConnect = false;
  bool _killSwitch = false;

  VpnProvider() {
    _selectedServer = _servers.first;
  }

  ConnectionState get connectionState => _connectionState;
  VpnServer? get selectedServer => _selectedServer;
  List<VpnServer> get servers => _servers;
  DateTime? get connectedSince => _connectedSince;
  double get dataUp => _dataUp;
  double get dataDown => _dataDown;
  bool get autoConnect => _autoConnect;
  bool get killSwitch => _killSwitch;

  bool get isConnected => _connectionState == ConnectionState.connected;
  bool get isConnecting => _connectionState == ConnectionState.connecting;
  bool get isDisconnected => _connectionState == ConnectionState.disconnected;

  String get connectionDuration {
    if (_connectedSince == null) return '00:00:00';
    final duration = DateTime.now().difference(_connectedSince!);
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String get formattedDataUp {
    if (_dataUp < 1024) return '${_dataUp.toStringAsFixed(1)} KB';
    return '${(_dataUp / 1024).toStringAsFixed(1)} MB';
  }

  String get formattedDataDown {
    if (_dataDown < 1024) return '${_dataDown.toStringAsFixed(1)} KB';
    return '${(_dataDown / 1024).toStringAsFixed(1)} MB';
  }

  void selectServer(VpnServer server) {
    _selectedServer = server;
    notifyListeners();
  }

  void setAutoConnect(bool value) {
    _autoConnect = value;
    notifyListeners();
  }

  void setKillSwitch(bool value) {
    _killSwitch = value;
    notifyListeners();
  }

  Future<void> toggleConnection() async {
    if (_connectionState == ConnectionState.connected) {
      await disconnect();
    } else if (_connectionState == ConnectionState.disconnected) {
      await connect();
    }
  }

  Future<void> connect() async {
    if (_selectedServer == null) return;

    _connectionState = ConnectionState.connecting;
    notifyListeners();

    // Simulate connection delay (1.5-3 seconds)
    await Future.delayed(const Duration(milliseconds: 2000));

    // TODO: Replace with real WireGuard tunnel setup
    // This is where wireguard_flutter or native channel code would go:
    // await WireGuardFlutter.connect(config: serverConfig);

    _connectionState = ConnectionState.connected;
    _connectedSince = DateTime.now();
    _dataUp = 0;
    _dataDown = 0;
    _startStatsSimulation();
    notifyListeners();
  }

  Future<void> disconnect() async {
    _connectionState = ConnectionState.disconnecting;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with real WireGuard tunnel teardown
    // await WireGuardFlutter.disconnect();

    _connectionState = ConnectionState.disconnected;
    _connectedSince = null;
    _stopStatsSimulation();
    notifyListeners();
  }

  void _startStatsSimulation() {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Simulate realistic-looking traffic
      _dataUp += 2.5 + (timer.tick % 5) * 1.2;
      _dataDown += 8.3 + (timer.tick % 7) * 3.1;
      notifyListeners();
    });
  }

  void _stopStatsSimulation() {
    _statsTimer?.cancel();
    _statsTimer = null;
  }

  @override
  void dispose() {
    _statsTimer?.cancel();
    super.dispose();
  }
}
