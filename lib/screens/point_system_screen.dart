import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class PointSystemScreen extends StatefulWidget {
  const PointSystemScreen({super.key});

  @override
  State<PointSystemScreen> createState() => _PointSystemScreenState();
}

class _PointSystemScreenState extends State<PointSystemScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _ringController;
  late final AnimationController _pulseController;

  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  late final Animation<double> _ringProgress;
  late final Animation<double> _pulse;

  int selectedTierIndex = 1;

  final List<_TierData> tiers = const [
    _TierData(
      name: 'Bronze',
      range: '0 - 2,999',
      minPoints: 0,
      maxPoints: 2999,
      icon: Icons.eco_rounded,
      color: Color(0xFFB9794B),
      description: 'Entry verified sustainability tier.',
    ),
    _TierData(
      name: 'Silver',
      range: '3,000 - 8,999',
      minPoints: 3000,
      maxPoints: 8999,
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFF78909C),
      description: 'Active recovery tier with visible verified impact.',
    ),
    _TierData(
      name: 'Gold',
      range: '9,000 - 19,999',
      minPoints: 9000,
      maxPoints: 19999,
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFFFB300),
      description: 'High-performing organization with priority recognition.',
    ),
    _TierData(
      name: 'Platinum',
      range: '20,000+',
      minPoints: 20000,
      maxPoints: 99999,
      icon: Icons.diamond_rounded,
      color: Color(0xFF04998B),
      description: 'Top-tier verified circular economy leader.',
    ),
  ];

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
      duration: const Duration(milliseconds: 750),
    );

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fade = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeOut,
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: Curves.easeOutCubic,
      ),
    );

    _ringProgress = Tween<double>(
      begin: 0,
      end: 0.72,
    ).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: Curves.easeOutCubic,
      ),
    );

    _pulse = Tween<double>(
      begin: 0.14,
      end: 0.32,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _introController.forward();
      _ringController.forward();
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _ringController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTier = tiers[selectedTierIndex];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: text,
        title: Text(
          'Point System',
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroCard(),
                const SizedBox(height: 18),
                _buildCurrentTierCard(),
                const SizedBox(height: 18),
                _buildTaxEligibilityCard(),
                const SizedBox(height: 18),
                _buildTierSelector(),
                const SizedBox(height: 18),
                _buildSelectedTierDetails(selectedTier),
                const SizedBox(height: 18),
                _buildEarningBreakdown(),
                const SizedBox(height: 18),
                _buildBenefitsGrid(),
                const SizedBox(height: 18),
                _buildTrustRuleCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, __) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
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
                color: AppColors.primaryGreen.withOpacity(_pulse.value),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -26,
                top: -24,
                child: Icon(
                  Icons.stars_rounded,
                  size: 135,
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 62,
                        width: 62,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.16),
                          ),
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Impact Tier Points',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Verified environmental credits that build your organization’s public impact tier.',
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
                      _heroMiniStat('Current', 'Silver'),
                      const SizedBox(width: 10),
                      _heroMiniStat('Points', '8,650'),
                      const SizedBox(width: 10),
                      _heroMiniStat('To Gold', '350'),
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

  Widget _heroMiniStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
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

  Widget _buildCurrentTierCard() {
    return Container(
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
          AnimatedBuilder(
            animation: _ringProgress,
            builder: (_, __) {
              return SizedBox(
                height: 104,
                width: 104,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: _ringProgress.value,
                      strokeWidth: 10,
                      backgroundColor: border,
                      color: AppColors.primaryGreen,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(_ringProgress.value * 100).round()}%',
                          style: TextStyle(
                            color: text,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'to Gold',
                          style: TextStyle(
                            color: muted,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Silver Tier',
                  style: TextStyle(
                    color: text,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '8,650 verified points',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Only 350 points away from Gold Tier.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 12.5,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _smallPill(
                      text: 'Badge Active',
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 8),
                    _smallPill(
                      text: 'Tax Eligible',
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

  Widget _smallPill({
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildTaxEligibilityCard() {
    return Container(
      width: double.infinity,
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
            right: -20,
            bottom: -26,
            child: Icon(
              Icons.receipt_long_rounded,
              color: Colors.white.withOpacity(0.10),
              size: 115,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tax Exemption Advantage',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Organizations that reach Silver Tier or above can submit a Tax Exemption Request supported by verified impact records.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 12.7,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Available from Silver Tier',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTierSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Explore Impact Tiers'),
        const SizedBox(height: 12),
        SizedBox(
          height: 122,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tiers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final tier = tiers[index];
              final selected = selectedTierIndex == index;
              final current = index == 1;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    selectedTierIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  width: 142,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: selected ? tier.color.withOpacity(0.18) : card,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: selected ? tier.color : border,
                      width: selected ? 1.6 : 1,
                    ),
                    boxShadow: selected
                        ? [
                      BoxShadow(
                        color: tier.color.withOpacity(0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        tier.icon,
                        color: tier.color,
                        size: 28,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${tier.name} Tier',
                              style: TextStyle(
                                color: text,
                                fontSize: 15.2,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (current)
                            Container(
                              height: 8,
                              width: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tier.range,
                        style: TextStyle(
                          color: muted,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedTierDetails(_TierData tier) {
    final bool eligibleForTax = tier.name != 'Bronze';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      child: Container(
        key: ValueKey(tier.name),
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _cardHeader(
              icon: tier.icon,
              iconColor: tier.color,
              title: '${tier.name} Tier',
              subtitle: tier.description,
            ),
            const SizedBox(height: 16),
            _detailRow(
              icon: Icons.stars_rounded,
              title: 'Required Points',
              value: tier.range,
              color: tier.color,
            ),
            const SizedBox(height: 12),
            _detailRow(
              icon: Icons.verified_rounded,
              title: 'Recognition',
              value: _tierRecognition(tier.name),
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 12),
            _detailRow(
              icon: Icons.insights_rounded,
              title: 'Platform Priority',
              value: _tierPriority(tier.name),
              color: AppColors.brightTeal,
            ),
            const SizedBox(height: 12),
            _detailRow(
              icon: Icons.receipt_long_rounded,
              title: 'Tax Exemption Request',
              value: eligibleForTax ? 'Eligible' : 'From Silver',
              color: eligibleForTax ? AppColors.freshGreen : Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }

  String _tierRecognition(String tier) {
    switch (tier) {
      case 'Bronze':
        return 'Basic public badge';
      case 'Silver':
        return 'Verified tier badge';
      case 'Gold':
        return 'Highlighted sustainability badge';
      default:
        return 'Premium leadership certificate';
    }
  }

  String _tierPriority(String tier) {
    switch (tier) {
      case 'Bronze':
        return 'Standard visibility';
      case 'Silver':
        return 'Improved visibility';
      case 'Gold':
        return 'Priority matching';
      default:
        return 'Highest network priority';
    }
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 23,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: text,
              fontSize: 12.7,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningBreakdown() {
    final rules = [
      _RuleData(
        icon: Icons.restaurant_rounded,
        title: 'Food donation pickup',
        points: '+8 / kg',
        color: Colors.orangeAccent,
        progress: 0.85,
      ),
      _RuleData(
        icon: Icons.inventory_2_rounded,
        title: 'Recycling pickup',
        points: '+4 / kg',
        color: AppColors.brightTeal,
        progress: 0.62,
      ),
      _RuleData(
        icon: Icons.eco_rounded,
        title: 'Composting recovery',
        points: '+6 / kg',
        color: AppColors.freshGreen,
        progress: 0.70,
      ),
      _RuleData(
        icon: Icons.local_fire_department_rounded,
        title: 'Urgent recovery bonus',
        points: '+20',
        color: Colors.redAccent,
        progress: 0.40,
      ),
      _RuleData(
        icon: Icons.verified_rounded,
        title: 'Reliable pickup streak',
        points: '+50',
        color: AppColors.primaryGreen,
        progress: 0.76,
      ),
    ];

    return _sectionCard(
      title: 'How Points Are Earned',
      icon: Icons.add_task_rounded,
      child: Column(
        children: rules.map(_earningRule).toList(),
      ),
    );
  }

  Widget _earningRule(_RuleData rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: rule.color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              rule.icon,
              color: rule.color,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: TextStyle(
                    color: text,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: rule.progress),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (_, value, __) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 7,
                        backgroundColor: border.withOpacity(0.5),
                        valueColor: AlwaysStoppedAnimation<Color>(rule.color),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            rule.points,
            style: TextStyle(
              color: rule.color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsGrid() {
    final benefits = [
      _BenefitData(
        icon: Icons.badge_rounded,
        title: 'Public Badge',
        color: AppColors.primaryGreen,
      ),
      _BenefitData(
        icon: Icons.description_rounded,
        title: 'Monthly Report',
        color: AppColors.brightTeal,
      ),
      _BenefitData(
        icon: Icons.travel_explore_rounded,
        title: 'Higher Visibility',
        color: Colors.orangeAccent,
      ),
      _BenefitData(
        icon: Icons.flash_on_rounded,
        title: 'Priority Matching',
        color: AppColors.freshGreen,
      ),
      _BenefitData(
        icon: Icons.receipt_long_rounded,
        title: 'Tax Exemption Request',
        color: const Color(0xFF7A9EEC),
      ),
    ];

    return _sectionCard(
      title: 'Tier Benefits',
      icon: Icons.card_giftcard_rounded,
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.55,
            children: benefits.map((benefit) {
              return Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: benefit.color.withOpacity(0.11),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: benefit.color.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      benefit.icon,
                      color: benefit.color,
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        benefit.title,
                        style: TextStyle(
                          color: text,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.09),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.primaryGreen.withOpacity(0.22),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: AppColors.primaryGreen,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tax Exemption Request is available for Silver Tier and above.',
                    style: TextStyle(
                      color: muted,
                      fontSize: 12.3,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrustRuleCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withOpacity(0.20),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.verified_user_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              'Points are awarded only after pickup verification. Posting alone does not generate official impact points.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.84),
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            icon: icon,
            iconColor: AppColors.primaryGreen,
            title: title,
            subtitle: null,
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _cardHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
  }) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.13),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: iconColor,
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
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: muted,
                    fontSize: 12.2,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: text,
        fontSize: 18,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _TierData {
  final String name;
  final String range;
  final int minPoints;
  final int maxPoints;
  final IconData icon;
  final Color color;
  final String description;

  const _TierData({
    required this.name,
    required this.range,
    required this.minPoints,
    required this.maxPoints,
    required this.icon,
    required this.color,
    required this.description,
  });
}

class _RuleData {
  final IconData icon;
  final String title;
  final String points;
  final Color color;
  final double progress;

  const _RuleData({
    required this.icon,
    required this.title,
    required this.points,
    required this.color,
    required this.progress,
  });
}

class _BenefitData {
  final IconData icon;
  final String title;
  final Color color;

  const _BenefitData({
    required this.icon,
    required this.title,
    required this.color,
  });
}