import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart' as vpn;
import '../theme.dart';
import 'server_list_screen.dart';
import 'settings_screen.dart';
import 'premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Color _getStatusColor(vpn.ConnectionState state) {
    switch (state) {
      case vpn.ConnectionState.connected:
        return XynthraColors.connected;
      case vpn.ConnectionState.connecting:
      case vpn.ConnectionState.disconnecting:
        return XynthraColors.connecting;
      case vpn.ConnectionState.disconnected:
        return XynthraColors.disconnected;
    }
  }

  String _getStatusText(vpn.ConnectionState state) {
    switch (state) {
      case vpn.ConnectionState.connected:
        return 'Connected';
      case vpn.ConnectionState.connecting:
        return 'Connecting...';
      case vpn.ConnectionState.disconnecting:
        return 'Disconnecting...';
      case vpn.ConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  IconData _getStatusIcon(vpn.ConnectionState state) {
    switch (state) {
      case vpn.ConnectionState.connected:
        return Icons.shield;
      case vpn.ConnectionState.connecting:
      case vpn.ConnectionState.disconnecting:
        return Icons.sync;
      case vpn.ConnectionState.disconnected:
        return Icons.shield_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<vpn.VpnProvider>(
      builder: (context, vpnProvider, _) {
        final statusColor = _getStatusColor(vpnProvider.connectionState);
        final isConnectedOrConnecting =
            vpnProvider.isConnected || vpnProvider.isConnecting;

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
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Premium button
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PremiumScreen(),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFf59e0b),
                                  Color(0xFFd97706),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  'PRO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Text(
                          'XynthraVPN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          ),
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: XynthraColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Status text
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: statusColor,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        statusColor.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _getStatusText(vpnProvider.connectionState),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // Connect button
                        GestureDetector(
                          onTap: vpnProvider.isConnecting
                              ? null
                              : () => vpnProvider.toggleConnection(),
                          child: AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              final scale = isConnectedOrConnecting
                                  ? _pulseAnimation.value
                                  : 1.0;
                              return Transform.scale(
                                scale: scale,
                                child: _buildConnectButton(
                                    vpnProvider, statusColor),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Connection duration
                        if (vpnProvider.isConnected)
                          Text(
                            vpnProvider.connectionDuration,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              letterSpacing: 4,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        if (!vpnProvider.isConnected && vpnProvider.connectionError == null)
                          const Text(
                            'Tap to connect',
                            style: TextStyle(
                              fontSize: 14,
                              color: XynthraColors.textMuted,
                            ),
                          ),
                        if (vpnProvider.connectionError != null && vpnProvider.isDisconnected)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              vpnProvider.connectionError!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: XynthraColors.error,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 32),
                        // Server info card
                        _buildServerCard(vpnProvider),
                        const SizedBox(height: 16),
                        // Stats (shown when connected)
                        if (vpnProvider.isConnected)
                          _buildStatsRow(vpnProvider),
                      ],
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

  Widget _buildConnectButton(
      vpn.VpnProvider vpnProvider, Color statusColor) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: vpnProvider.isConnected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  XynthraColors.accent,
                  XynthraColors.accentDark,
                ],
              )
            : vpnProvider.isConnecting
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      XynthraColors.connecting,
                      Color(0xFFd97706),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      XynthraColors.cardBgLight,
                      XynthraColors.cardBg,
                    ],
                  ),
        boxShadow: [
          BoxShadow(
            color: statusColor.withValues(alpha: 0.3),
            blurRadius: 40,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: statusColor.withValues(alpha: 0.1),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: vpnProvider.isConnecting
            ? Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * pi,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              statusColor.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Icon(
                    Icons.sync,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    vpnProvider.isConnected
                        ? Icons.shield
                        : Icons.power_settings_new_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vpnProvider.isConnected ? 'ON' : 'OFF',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildServerCard(vpn.VpnProvider vpnProvider) {
    final server = vpnProvider.selectedServer;
    if (server == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ServerListScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: XynthraColors.cardBg.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: XynthraColors.cardBgLight.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Flag placeholder
            Container(
              width: 40,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: XynthraColors.primary.withValues(alpha: 0.2),
              ),
              child: const Center(
                child: Text(
                  'NL',
                  style: TextStyle(
                    color: XynthraColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    server.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    server.maskedIp,
                    style: const TextStyle(
                      color: XynthraColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            // Ping
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: XynthraColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${server.ping}ms',
                style: const TextStyle(
                  color: XynthraColors.accent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: XynthraColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(vpn.VpnProvider vpnProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.arrow_upward_rounded,
              label: 'Upload',
              value: vpnProvider.formattedDataUp,
              color: XynthraColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.arrow_downward_rounded,
              label: 'Download',
              value: vpnProvider.formattedDataDown,
              color: XynthraColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XynthraColors.cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: XynthraColors.cardBgLight.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: XynthraColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
