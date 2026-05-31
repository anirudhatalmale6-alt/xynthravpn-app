import 'package:flutter/services.dart';

class NativeVpnService {
  static const _channel = MethodChannel('com.xynthravpn/vpn');

  static Future<bool> connect(String config) async {
    try {
      final result = await _channel.invokeMethod('connect', {'config': config});
      return result?['status'] == 'connected';
    } on PlatformException catch (e) {
      if (e.code == 'VPN_DENIED') return false;
      rethrow;
    }
  }

  static Future<bool> disconnect() async {
    try {
      final result = await _channel.invokeMethod('disconnect');
      return result?['status'] == 'disconnected';
    } on PlatformException {
      return false;
    }
  }

  static Future<String> getStatus() async {
    try {
      final result = await _channel.invokeMethod('getStatus');
      return result?['state'] ?? 'unknown';
    } on PlatformException {
      return 'unknown';
    }
  }

  static Future<Map<String, int>> getStats() async {
    try {
      final result = await _channel.invokeMethod('getStats');
      if (result == null) return {};
      return {
        'rx': (result['rx'] as num?)?.toInt() ?? 0,
        'tx': (result['tx'] as num?)?.toInt() ?? 0,
      };
    } on PlatformException {
      return {};
    }
  }
}
