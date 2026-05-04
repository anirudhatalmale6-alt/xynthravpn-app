import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/server_model.dart';
import '../services/vpn_service.dart';

enum ConnectionState { disconnected, connecting, connected, disconnecting }

class VpnProvider extends ChangeNotifier {
  ConnectionState _connectionState = ConnectionState.disconnected;
  VpnServer? _selectedServer;
  final List<VpnServer> _servers = VpnServer.defaultServers;
  DateTime? _connectedSince;
  Timer? _statsTimer;
  Timer? _durationTimer;
  String? _connectionError;

  int _rxBytes = 0;
  int _txBytes = 0;

  bool _autoConnect = false;
  bool _killSwitch = false;

  VpnProvider() {
    _selectedServer = _servers.first;
    _measurePings();
  }

  ConnectionState get connectionState => _connectionState;
  VpnServer? get selectedServer => _selectedServer;
  List<VpnServer> get servers => _servers;
  DateTime? get connectedSince => _connectedSince;
  int get rxBytes => _rxBytes;
  int get txBytes => _txBytes;
  bool get autoConnect => _autoConnect;
  bool get killSwitch => _killSwitch;
  String? get connectionError => _connectionError;

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

  String get formattedDataUp => _formatBytes(_txBytes);
  String get formattedDataDown => _formatBytes(_rxBytes);

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
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

    _connectionError = null;
    _connectionState = ConnectionState.connecting;
    notifyListeners();

    try {
      final success = await NativeVpnService.connect(_selectedServer!.wgConfig);

      if (success) {
        _connectionState = ConnectionState.connected;
        _connectedSince = DateTime.now();
        _rxBytes = 0;
        _txBytes = 0;
        _startStatsPolling();
        _startDurationTimer();
      } else {
        _connectionError = 'VPN permission denied';
        _connectionState = ConnectionState.disconnected;
      }
    } catch (e) {
      _connectionError = e.toString();
      _connectionState = ConnectionState.disconnected;
    }

    notifyListeners();
  }

  Future<void> disconnect() async {
    _connectionState = ConnectionState.disconnecting;
    notifyListeners();

    try {
      await NativeVpnService.disconnect();
    } catch (e) {
      debugPrint('Disconnect error: $e');
    }

    _connectionState = ConnectionState.disconnected;
    _connectedSince = null;
    _stopStatsPolling();
    _stopDurationTimer();
    notifyListeners();
  }

  void _startStatsPolling() {
    _statsTimer?.cancel();
    _statsTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      try {
        final stats = await NativeVpnService.getStats();
        if (stats.isNotEmpty) {
          _rxBytes = stats['rx'] ?? _rxBytes;
          _txBytes = stats['tx'] ?? _txBytes;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Stats poll error: $e');
      }
    });
  }

  void _stopStatsPolling() {
    _statsTimer?.cancel();
    _statsTimer = null;
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  Future<void> _measurePings() async {
    for (final server in _servers) {
      try {
        final stopwatch = Stopwatch()..start();
        final socket = await Socket.connect(
          server.ipAddress,
          51820,
          timeout: const Duration(seconds: 3),
        );
        stopwatch.stop();
        socket.destroy();
        server.ping = stopwatch.elapsedMilliseconds;
        server.signalStrength = server.ping < 30 ? 3 : (server.ping < 80 ? 2 : 1);
      } catch (e) {
        server.ping = 999;
        server.signalStrength = 0;
      }
    }
    _servers.sort((a, b) => a.ping.compareTo(b.ping));
    _selectedServer = _servers.first;
    notifyListeners();
  }

  Future<void> refreshPings() async {
    await _measurePings();
  }

  @override
  void dispose() {
    _statsTimer?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }
}
