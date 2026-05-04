import 'package:flutter/material.dart';
import '../theme.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'Upgrade Plan',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Crown icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFf59e0b),
                              Color(0xFFd97706),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFf59e0b)
                                  .withValues(alpha: 0.3),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Choose Your Plan',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Unlock the full power of XynthraVPN',
                        style: TextStyle(
                          fontSize: 15,
                          color: XynthraColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Free plan
                      _buildPlanCard(
                        name: 'Free',
                        price: '\$0',
                        period: '/forever',
                        features: [
                          '1 device',
                          '1 server location',
                          'Limited speed',
                          'Basic encryption',
                        ],
                        isCurrentPlan: true,
                        gradientColors: [
                          XynthraColors.cardBg,
                          XynthraColors.cardBg,
                        ],
                        borderColor: XynthraColors.cardBgLight,
                      ),
                      const SizedBox(height: 16),
                      // Pro plan
                      _buildPlanCard(
                        name: 'Pro',
                        price: '\$4.99',
                        period: '/month',
                        features: [
                          '5 devices',
                          'All 8 server locations',
                          'Unlimited speed',
                          'Advanced encryption',
                          'Kill switch',
                          'No ads',
                        ],
                        isPopular: true,
                        gradientColors: [
                          XynthraColors.primary.withValues(alpha: 0.15),
                          XynthraColors.cardBg,
                        ],
                        borderColor: XynthraColors.primary,
                      ),
                      const SizedBox(height: 16),
                      // Business plan
                      _buildPlanCard(
                        name: 'Business',
                        price: '\$12.99',
                        period: '/month',
                        features: [
                          'Unlimited devices',
                          'All server locations',
                          'Dedicated IP option',
                          'Priority support',
                          'Team management',
                          'Custom DNS',
                          'API access',
                        ],
                        gradientColors: [
                          const Color(0xFFf59e0b).withValues(alpha: 0.1),
                          XynthraColors.cardBg,
                        ],
                        borderColor: const Color(0xFFf59e0b),
                      ),
                      const SizedBox(height: 24),
                      // Coming soon notice
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: XynthraColors.primary
                              .withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: XynthraColors.primary
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              color: XynthraColors.primaryLight,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Coming Soon',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'In-app purchases will be available in the next update. Stay tuned!',
                                    style: TextStyle(
                                      color: XynthraColors.textSecondary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String name,
    required String price,
    required String period,
    required List<String> features,
    required List<Color> gradientColors,
    required Color borderColor,
    bool isPopular = false,
    bool isCurrentPlan = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor.withValues(alpha: 0.4),
          width: isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: XynthraColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (isCurrentPlan)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: XynthraColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: XynthraColors.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Text(
                    'CURRENT',
                    style: TextStyle(
                      color: XynthraColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Price
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  period,
                  style: const TextStyle(
                    color: XynthraColors.textMuted,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Features
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: isCurrentPlan
                          ? XynthraColors.textMuted
                          : XynthraColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      feature,
                      style: const TextStyle(
                        color: XynthraColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )),
          if (!isCurrentPlan) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Coming soon
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPopular
                      ? XynthraColors.primary
                      : XynthraColors.cardBgLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Coming Soon',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isPopular
                        ? Colors.white
                        : XynthraColors.textSecondary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
