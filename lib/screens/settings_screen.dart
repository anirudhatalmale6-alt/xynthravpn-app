import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vpn_provider.dart';
import '../theme.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final vpn = context.watch<VpnProvider>();

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 12),
                    // Account section
                    _buildSectionHeader('Account'),
                    _buildCard(
                      child: Column(
                        children: [
                          _buildAccountTile(auth),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Connection section
                    _buildSectionHeader('Connection'),
                    _buildCard(
                      child: Column(
                        children: [
                          _buildSwitchTile(
                            icon: Icons.play_circle_outline_rounded,
                            title: 'Auto-connect on startup',
                            subtitle: 'Connect automatically when app opens',
                            value: vpn.autoConnect,
                            onChanged: (val) => vpn.setAutoConnect(val),
                          ),
                          _buildDivider(),
                          _buildSwitchTile(
                            icon: Icons.block_rounded,
                            title: 'Kill Switch',
                            subtitle:
                                'Block internet if VPN disconnects',
                            value: vpn.killSwitch,
                            onChanged: (val) => vpn.setKillSwitch(val),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Protocol section
                    _buildSectionHeader('Protocol'),
                    _buildCard(
                      child: _buildInfoTile(
                        icon: Icons.security_rounded,
                        title: 'WireGuard',
                        subtitle:
                            'Modern, fast, and secure VPN protocol',
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                XynthraColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Active',
                            style: TextStyle(
                              color: XynthraColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // About section
                    _buildSectionHeader('About'),
                    _buildCard(
                      child: Column(
                        children: [
                          _buildInfoTile(
                            icon: Icons.info_outline_rounded,
                            title: 'Version',
                            subtitle: '1.1.0 (Build 2)',
                          ),
                          _buildDivider(),
                          _buildInfoTile(
                            icon: Icons.description_outlined,
                            title: 'Privacy Policy',
                            subtitle: 'Read our privacy policy',
                            trailing: const Icon(
                              Icons.open_in_new_rounded,
                              color: XynthraColors.textMuted,
                              size: 18,
                            ),
                          ),
                          _buildDivider(),
                          _buildInfoTile(
                            icon: Icons.gavel_rounded,
                            title: 'Terms of Service',
                            subtitle: 'Read terms and conditions',
                            trailing: const Icon(
                              Icons.open_in_new_rounded,
                              color: XynthraColors.textMuted,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Logout button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await auth.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: XynthraColors.error,
                          side: BorderSide(
                            color:
                                XynthraColors.error.withValues(alpha: 0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: XynthraColors.textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: XynthraColors.cardBg.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: XynthraColors.cardBgLight.withValues(alpha: 0.5),
        ),
      ),
      child: child,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      color: XynthraColors.cardBgLight.withValues(alpha: 0.5),
    );
  }

  Widget _buildAccountTile(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  XynthraColors.primary,
                  XynthraColors.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.isGuest ? 'Guest User' : auth.email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  auth.isGuest ? 'Limited access' : 'Free plan',
                  style: const TextStyle(
                    color: XynthraColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: XynthraColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: XynthraColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: XynthraColors.primary,
            activeTrackColor: XynthraColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: XynthraColors.textMuted,
            inactiveTrackColor: XynthraColors.cardBgLight,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: XynthraColors.textSecondary, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: XynthraColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
