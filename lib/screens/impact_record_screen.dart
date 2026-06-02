import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../data/demo_app_state.dart';

class ImpactRecordScreen extends StatefulWidget {
  const ImpactRecordScreen({super.key});

  @override
  State<ImpactRecordScreen> createState() => _ImpactRecordScreenState();
}

class _ImpactRecordScreenState extends State<ImpactRecordScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _glowController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _glowAnimation;

  int selectedRangeIndex = 1;

  final List<String> ranges = ['Week', 'Month', 'Quarter'];

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg => isDark ? const Color(0xFF081A16) : AppColors.softBackground;
  Color get card => isDark ? const Color(0xFF122823) : AppColors.white;
  Color get cardSoft =>
      isDark ? const Color(0xFF0F221E) : const Color(0xFFF7FBF9);
  Color get text => isDark ? const Color(0xFFEAF6F0) : AppColors.charcoal;
  Color get muted =>
      isDark ? const Color(0xFFA9BDB4) : AppColors.charcoal.withOpacity(0.60);
  Color get border => isDark ? const Color(0xFF24433A) : AppColors.mintBorder;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 780),
    );

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.045),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
      ),
    );

    _glowAnimation = Tween<double>(
      begin: 0.16,
      end: 0.34,
    ).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _introController.forward();
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Map<String, dynamic> dashboardDataFromStats(DemoImpactStats stats) {
    switch (selectedRangeIndex) {
      case 0:
        return {
          'waste': (stats.wasteKg * 0.15).round(),
          'points': (stats.points * 0.15).round(),
          'pickups': (stats.verifiedPickups * 0.15).round(),
          'meals': (stats.mealsSupported * 0.15).round(),
          'goalProgress': 0.64,
          'goalLabel': '64% to Gold',
          'bars': [28, 36, 18, 44, 32, 54, 46],
          'mix': [
            {
              'name': 'Surplus Food',
              'value': 0.42,
              'color': Colors.orangeAccent,
            },
            {
              'name': 'Cardboard',
              'value': 0.24,
              'color': AppColors.brightTeal,
            },
            {
              'name': 'Organic Waste',
              'value': 0.20,
              'color': AppColors.freshGreen,
            },
            {
              'name': 'Plastic',
              'value': 0.14,
              'color': const Color(0xFF7A9EEC),
            },
          ],
        };

      case 2:
        return {
          'waste': (stats.wasteKg * 2.8).round(),
          'points': (stats.points * 2.5).round(),
          'pickups': (stats.verifiedPickups * 2.4).round(),
          'meals': (stats.mealsSupported * 2.8).round(),
          'goalProgress': 0.86,
          'goalLabel': '86% to Gold',
          'bars': [48, 62, 58, 74, 69, 82, 76],
          'mix': [
            {
              'name': 'Surplus Food',
              'value': 0.38,
              'color': Colors.orangeAccent,
            },
            {
              'name': 'Cardboard',
              'value': 0.27,
              'color': AppColors.brightTeal,
            },
            {
              'name': 'Organic Waste',
              'value': 0.21,
              'color': AppColors.freshGreen,
            },
            {
              'name': 'Plastic',
              'value': 0.14,
              'color': const Color(0xFF7A9EEC),
            },
          ],
        };

      default:
        return {
          'waste': stats.wasteKg,
          'points': stats.points,
          'pickups': stats.verifiedPickups,
          'meals': stats.mealsSupported,
          'goalProgress': 0.72,
          'goalLabel': '72% to Gold',
          'bars': [24, 34, 28, 42, 39, 51, 47],
          'mix': [
            {
              'name': 'Surplus Food',
              'value': 0.40,
              'color': Colors.orangeAccent,
            },
            {
              'name': 'Cardboard',
              'value': 0.25,
              'color': AppColors.brightTeal,
            },
            {
              'name': 'Organic Waste',
              'value': 0.21,
              'color': AppColors.freshGreen,
            },
            {
              'name': 'Plastic',
              'value': 0.14,
              'color': const Color(0xFF7A9EEC),
            },
          ],
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DemoImpactStats>(
      valueListenable: DemoAppState.impactStats,
      builder: (context, stats, _) {
        final data = dashboardDataFromStats(stats);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            foregroundColor: text,
            title: Text(
              'Impact Dashboard',
              style: TextStyle(
                color: text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroSection(data),
                    const SizedBox(height: 18),
                    _buildRangeSelector(),
                    const SizedBox(height: 18),
                    _buildSummaryGrid(data),
                    const SizedBox(height: 18),
                    _buildTierProgressCard(data),
                    const SizedBox(height: 18),
                    _buildPerformanceSection(data),
                    const SizedBox(height: 18),
                    _buildRecoveryMixSection(data),
                    const SizedBox(height: 18),
                    _buildQuickActions(),
                    const SizedBox(height: 18),
                    _buildRecentActivity(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroSection(Map<String, dynamic> data) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryGreen,
                AppColors.deepTeal,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(_glowAnimation.value),
                blurRadius: 26,
                offset: const Offset(0, 11),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -18,
                right: -20,
                child: Icon(
                  Icons.insights_rounded,
                  size: 128,
                  color: Colors.white.withOpacity(0.09),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.16),
                          ),
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          color: Colors.white,
                          size: 31,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verified Impact Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Live recovery performance built from verified pickups.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.8,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _heroMetric(
                        title: 'Recovered',
                        value: '${data['waste']} kg',
                      ),
                      const SizedBox(width: 10),
                      _heroMetric(
                        title: 'Points',
                        value: '${data['points']}',
                      ),
                      const SizedBox(width: 10),
                      _heroMetric(
                        title: 'Pickups',
                        value: '${data['pickups']}',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _heroMetric({
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.13),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.10),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontSize: 10.8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeSelector() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ranges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedRangeIndex == index;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                selectedRangeIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryGreen : card,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? AppColors.primaryGreen : border,
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                ranges[index],
                style: TextStyle(
                  color: selected ? Colors.white : muted,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryGrid(Map<String, dynamic> data) {
    return GridView.count(
      key: ValueKey(selectedRangeIndex),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.24,
      children: [
        _summaryCard(
          icon: Icons.delete_outline_rounded,
          value: '${data['waste']} kg',
          label: 'Waste Diverted',
          accent: AppColors.primaryGreen,
          delay: 0,
        ),
        _summaryCard(
          icon: Icons.stars_rounded,
          value: '${data['points']}',
          label: 'Impact Points',
          accent: AppColors.freshGreen,
          delay: 80,
        ),
        _summaryCard(
          icon: Icons.verified_rounded,
          value: '${data['pickups']}',
          label: 'Verified Pickups',
          accent: AppColors.brightTeal,
          delay: 160,
        ),
        _summaryCard(
          icon: Icons.restaurant_rounded,
          value: '${data['meals']}',
          label: 'Meals Supported',
          accent: Colors.orangeAccent,
          delay: 240,
        ),
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String value,
    required String label,
    required Color accent,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.88, end: 1.0),
      duration: Duration(milliseconds: 440 + delay),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: border),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(isDark ? 0.04 : 0.10),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.13),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: accent,
                size: 23,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                color: text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: muted,
                fontSize: 11.8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierProgressCard(Map<String, dynamic> data) {
    final progress = data['goalProgress'] as double;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(isDark ? 0.04 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            key: ValueKey(selectedRangeIndex),
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
            builder: (_, value, __) {
              return SizedBox(
                height: 86,
                width: 86,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 9,
                      backgroundColor: border,
                      color: AppColors.primaryGreen,
                    ),
                    Text(
                      '${(value * 100).round()}%',
                      style: TextStyle(
                        color: text,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Silver Tier',
                  style: TextStyle(
                    color: text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data['goalLabel'],
                  style: TextStyle(
                    color: muted,
                    fontSize: 12.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 11),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _miniPill(
                      label: 'Badge Active',
                      color: AppColors.primaryGreen,
                    ),
                    _miniPill(
                      label: 'Tax Eligible',
                      color: AppColors.brightTeal,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniPill({
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildPerformanceSection(Map<String, dynamic> data) {
    final bars = List<int>.from(data['bars'] as List);
    final maxValue = bars.reduce((a, b) => a > b ? a : b).toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            title: 'Performance Trend',
            subtitle: 'Recovered impact across recent days',
            icon: Icons.show_chart_rounded,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 174,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (index) {
                final labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                final value = bars[index].toDouble();

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TweenAnimationBuilder<double>(
                          key: ValueKey('$selectedRangeIndex-$index'),
                          tween: Tween(begin: 0, end: value / maxValue),
                          duration: Duration(milliseconds: 520 + (index * 85)),
                          curve: Curves.easeOutCubic,
                          builder: (_, progress, __) {
                            return Container(
                              height: 112 * progress,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryGreen,
                                    index.isEven
                                        ? AppColors.deepTeal
                                        : AppColors.brightTeal,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryGreen.withOpacity(
                                      isDark ? 0.05 : 0.12,
                                    ),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          labels[index],
                          style: TextStyle(
                            color: muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryMixSection(Map<String, dynamic> data) {
    final mix = List<Map<String, dynamic>>.from(data['mix'] as List);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            title: 'Recovery Mix',
            subtitle: 'How recovered materials are distributed',
            icon: Icons.pie_chart_outline_rounded,
          ),
          const SizedBox(height: 16),
          ...mix.map((item) {
            final value = item['value'] as double;
            final color = item['color'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item['name'] as String,
                          style: TextStyle(
                            color: text,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${(value * 100).round()}%',
                        style: TextStyle(
                          color: color,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey('${selectedRangeIndex}-${item['name']}'),
                      tween: Tween(begin: 0, end: value),
                      duration: const Duration(milliseconds: 720),
                      curve: Curves.easeOutCubic,
                      builder: (_, progress, __) {
                        return LinearProgressIndicator(
                          value: progress,
                          minHeight: 10,
                          backgroundColor: cardSoft,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -24,
            child: Icon(
              Icons.insert_chart_rounded,
              size: 110,
              color: Colors.white.withOpacity(0.09),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Impact Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Use verified impact data for reports, badges, and future incentive applications.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.74),
                  fontSize: 12.8,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _quickActionButton(
                      icon: Icons.description_rounded,
                      label: 'Preview Report',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showMessage('Monthly report preview opened.');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quickActionButton(
                      icon: Icons.ios_share_rounded,
                      label: 'Export Summary',
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showMessage('Impact summary exported.');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(
          color: Colors.white.withOpacity(0.35),
        ),
        padding: const EdgeInsets.symmetric(vertical: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      _ImpactActivity(
        icon: Icons.restaurant_rounded,
        color: Colors.orangeAccent,
        title: 'Surplus food pickup verified',
        subtitle: 'Hope Charity • 80 points awarded',
        time: '2h ago',
      ),
      _ImpactActivity(
        icon: Icons.inventory_2_rounded,
        color: AppColors.brightTeal,
        title: 'Cardboard recovery completed',
        subtitle: 'Amman Recycling Co. • 45 points awarded',
        time: 'Yesterday',
      ),
      _ImpactActivity(
        icon: Icons.eco_rounded,
        color: AppColors.freshGreen,
        title: 'Organic waste redirected',
        subtitle: 'Amman Compost Hub • 60 points awarded',
        time: '2 days ago',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(
            title: 'Recent Verified Activity',
            subtitle: 'Latest completed recovery actions',
            icon: Icons.history_rounded,
          ),
          const SizedBox(height: 16),
          ...List.generate(activities.length, (index) {
            final item = activities[index];

            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.94, end: 1.0),
              duration: Duration(milliseconds: 360 + (index * 90)),
              curve: Curves.easeOutBack,
              builder: (_, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: index == activities.length - 1 ? 0 : 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        item.icon,
                        color: item.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cardSoft,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: border.withOpacity(0.8)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color: text,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.subtitle,
                                    style: TextStyle(
                                      color: muted,
                                      fontSize: 11.8,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item.time,
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 23,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: text,
                  fontSize: 17.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: muted,
                  fontSize: 11.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepTeal,
      ),
    );
  }
}

class _ImpactActivity {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String time;

  const _ImpactActivity({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}