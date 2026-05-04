class VpnServer {
  final String id;
  final String name;
  final String ipAddress;
  final String country;
  final String countryCode;
  final int ping;
  final int signalStrength; // 0-3

  const VpnServer({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.country,
    required this.countryCode,
    required this.ping,
    required this.signalStrength,
  });

  String get maskedIp {
    final parts = ipAddress.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.${parts[1]}.***.${parts[3]}';
    }
    return ipAddress;
  }

  static List<VpnServer> get defaultServers => const [
    VpnServer(
      id: 'ams1',
      name: 'Amsterdam 1',
      ipAddress: '85.17.244.167',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 12,
      signalStrength: 3,
    ),
    VpnServer(
      id: 'ams2',
      name: 'Amsterdam 2',
      ipAddress: '94.75.223.85',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 15,
      signalStrength: 3,
    ),
    VpnServer(
      id: 'ams3',
      name: 'Amsterdam 3',
      ipAddress: '95.211.164.41',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 18,
      signalStrength: 3,
    ),
    VpnServer(
      id: 'ams4',
      name: 'Amsterdam 4',
      ipAddress: '85.17.192.6',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 22,
      signalStrength: 2,
    ),
    VpnServer(
      id: 'ams5',
      name: 'Amsterdam 5',
      ipAddress: '85.17.67.240',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 25,
      signalStrength: 2,
    ),
    VpnServer(
      id: 'ams6',
      name: 'Amsterdam 6',
      ipAddress: '85.17.67.239',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 20,
      signalStrength: 2,
    ),
    VpnServer(
      id: 'ams7',
      name: 'Amsterdam 7',
      ipAddress: '85.17.83.99',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 30,
      signalStrength: 2,
    ),
    VpnServer(
      id: 'ams8',
      name: 'Amsterdam 8',
      ipAddress: '94.75.227.141',
      country: 'Netherlands',
      countryCode: 'NL',
      ping: 16,
      signalStrength: 3,
    ),
  ];
}
