class VpnServer {
  final String id;
  final String name;
  final String ipAddress;
  final String country;
  final String countryCode;
  final String wgConfig;
  int ping;
  int signalStrength;

  VpnServer({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.country,
    required this.countryCode,
    required this.wgConfig,
    this.ping = 0,
    this.signalStrength = 0,
  });

  String get maskedIp {
    final parts = ipAddress.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.${parts[1]}.***.${parts[3]}';
    }
    return ipAddress;
  }

  static List<VpnServer> get defaultServers => [
    VpnServer(
      id: 'nl-ams-1',
      name: 'Netherlands #1',
      ipAddress: '85.17.244.167',
      country: 'Netherlands',
      countryCode: 'NL',
      wgConfig: '''[Interface]
PrivateKey = IH9ODtFAJQAZM1slAC6G96PnOmDJpTI1oi5yPScqgFk=
Address = 10.8.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = 6XTcbaZWaSbDzX659OpXiSV4t8oUPXVLFCsaw1txYz8=
PresharedKey = 7V37Vn4DCF4faYSjDaERZ/bb9azkCvtUMUeTXNbHqu8=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 85.17.244.167:51820''',
    ),
    VpnServer(
      id: 'nl-ams-2',
      name: 'Netherlands #2',
      ipAddress: '94.75.223.85',
      country: 'Netherlands',
      countryCode: 'NL',
      wgConfig: '''[Interface]
PrivateKey = WL0kr1ZgjGUZeZjJ1aDPjqPZPIho9m2O+gmiR5EfkG0=
Address = 10.8.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = /6/0pLiMd+JiWFShKX0t1WVLKMx1V4kgVget+3B5/wE=
PresharedKey = +LDAIUxEhsc3JiFQ5IgXocXmnV/2avB19EMLkdsi+Yc=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 94.75.223.85:51820''',
    ),
    VpnServer(
      id: 'nl-ams-3',
      name: 'Netherlands #3',
      ipAddress: '95.211.164.41',
      country: 'Netherlands',
      countryCode: 'NL',
      wgConfig: '''[Interface]
PrivateKey = sOYU0ROL2X0N0Bfbd9mEyvfl0rIIcgnbxNv1FucjyFs=
Address = 10.8.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = Fo1iJHjrHAGf9acieZpTcoJDqUqdmefe4S7Bw+QT4Go=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 95.211.164.41:51820''',
    ),
    VpnServer(
      id: 'nl-ams-4',
      name: 'Netherlands #4',
      ipAddress: '85.17.192.6',
      country: 'Netherlands',
      countryCode: 'NL',
      wgConfig: '''[Interface]
PrivateKey = UI+Bm1v6IkBMetps+EyGz4Uz5y54Mt7Z6GEUEdpWymU=
Address = 10.8.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = qwKplYnxZB+PN9e0iYRjRthp7zVELbXbgLhTLW8rxgM=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 85.17.192.6:51820''',
    ),
    VpnServer(
      id: 'nl-ams-5',
      name: 'Netherlands #5',
      ipAddress: '85.17.67.240',
      country: 'Netherlands',
      countryCode: 'NL',
      wgConfig: '''[Interface]
PrivateKey = cF7L8VAnDWGWYzBBES9GhQ7S6KzImVaALyeeL4kHrUo=
Address = 10.8.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = ydGDlmYo1fD2q9ILP0+krA5RKszKBUzQz9hGcsW0HAA=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 85.17.67.240:51820''',
    ),
    VpnServer(
      id: 'nl-ams-6',
      name: 'Netherlands #6',
      ipAddress: '85.17.67.239',
      country: 'Netherlands',
      countryCode: 'NL',
      wgConfig: '''[Interface]
PrivateKey = qP0aSC9Gfy5wh6b002uChwmJu52ADlhBviREspd5O0o=
Address = 10.8.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = I3Jjrw4/5ZBTTRPFswVyHK9hUXktZ7XClV6X7YIhjmc=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 85.17.67.239:51820''',
    ),
  ];
}
