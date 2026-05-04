import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../models/server_model.dart';
import '../theme.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  Widget _buildSignalIcon(int strength) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(4, (index) {
        final isActive = index < strength;
        return Container(
          margin: const EdgeInsets.only(right: 2),
          width: 3,
          height: 6.0 + (index * 4),
          decoration: BoxDecoration(
            color: isActive
                ? (strength >= 3
                    ? XynthraColors.accent
                    : strength >= 2
                        ? XynthraColors.connecting
                        : XynthraColors.error)
                : XynthraColors.cardBgLight,
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, vpnProvider, _) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF12132e), XynthraColors.background],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Select Server',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48), // balance
                      ],
                    ),
                  ),
                  // Info bar
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: XynthraColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            XynthraColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: XynthraColors.primaryLight, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'All servers use WireGuard protocol for maximum speed',
                            style: TextStyle(
                              color: XynthraColors.primaryLight,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Region header
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, right: 24, top: 16, bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: XynthraColors.primary
                                .withValues(alpha: 0.15),
                          ),
                          child: const Center(
                            child: Text(
                              'NL',
                              style: TextStyle(
                                color: XynthraColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Netherlands',
                          style: TextStyle(
                            color: XynthraColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${vpnProvider.servers.length} servers',
                          style: const TextStyle(
                            color: XynthraColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Server list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: vpnProvider.servers.length,
                      itemBuilder: (context, index) {
                        final server = vpnProvider.servers[index];
                        final isSelected =
                            server.id == vpnProvider.selectedServer?.id;
                        return _buildServerTile(
                          context,
                          server,
                          isSelected,
                          vpnProvider,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServerTile(
    BuildContext context,
    VpnServer server,
    bool isSelected,
    VpnProvider vpnProvider,
  ) {
    return GestureDetector(
      onTap: () {
        vpnProvider.selectServer(server);
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? XynthraColors.primary.withValues(alpha: 0.15)
              : XynthraColors.cardBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? XynthraColors.primary.withValues(alpha: 0.4)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Server icon
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? XynthraColors.primary.withValues(alpha: 0.2)
                    : XynthraColors.cardBgLight.withValues(alpha: 0.5),
              ),
              child: Icon(
                Icons.dns_rounded,
                color: isSelected
                    ? XynthraColors.primary
                    : XynthraColors.textMuted,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // Server info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : XynthraColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    server.maskedIp,
                    style: const TextStyle(
                      color: XynthraColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Signal strength
            _buildSignalIcon(server.signalStrength),
            const SizedBox(width: 12),
            // Ping
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: XynthraColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${server.ping}ms',
                style: const TextStyle(
                  color: XynthraColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Selected checkmark
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: XynthraColors.primary,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              )
            else
              const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
