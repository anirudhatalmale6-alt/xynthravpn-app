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
      id: 'de-fra-1',
      name: 'Germany #1',
      ipAddress: '38.54.13.118',
      country: 'Germany',
      countryCode: 'DE',
      wgConfig: '''[Interface]
PrivateKey = 8PAlStyOrOUtqnRwD3kYj1DDMKFFEAkLQCMgxBw3m0w=
Address = 10.8.1.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = ABMUddaVM6js4cN2MUfR3DIryPXEmMDfo3B483LLZTM=
PresharedKey = r5h+Jes62B7nOGc+f/9mz4rfTIY69aMUp4YBNf5Elro=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 38.54.13.118:51820''',
    ),
    VpnServer(
      id: 'us-was-1',
      name: 'United States #1',
      ipAddress: '38.54.6.72',
      country: 'United States',
      countryCode: 'US',
      wgConfig: '''[Interface]
PrivateKey = IMQU0Jk1Sad1ZhR1QuIHjOK/FAaO5NPeUVuBfTeyJ1E=
Address = 10.8.3.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = qxi3LPqjD1O4FpxjtJUcmTY/pH+JCmtsOSAPugmEHGU=
PresharedKey = g7kCFyXiWuxW4ZC4kNcLWbg8ZCut6HP9KYklfdubBrk=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 38.54.6.72:51820''',
    ),
    VpnServer(
      id: 'co-bog-1',
      name: 'Colombia #1',
      ipAddress: '130.94.110.93',
      country: 'Colombia',
      countryCode: 'CO',
      wgConfig: '''[Interface]
PrivateKey = ULQD44BePK2yiyG3ipyIqzvA21zbFfUJ7E8AbPoIZUw=
Address = 10.8.2.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = xIwh5KS7CCdFsgYeGZs/vwECvplgGU5tx/U5XNtPCWc=
PresharedKey = vpzjMg8yGCweiqoehLs0S55+YfgzZxkUFED16LxLw+M=
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
Endpoint = 130.94.110.93:51820''',
    ),
  ];
}
