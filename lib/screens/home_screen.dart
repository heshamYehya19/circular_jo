import 'dart:async';
import 'dart:math';

import 'package:circular_jo/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'post_material_screen.dart';
import '../constants/theme_controller.dart';

import 'listings_screen.dart';

// ─── Color Tokens ────────────────────────────────────────────────────────────
class _HomeColors {
  static bool isDark = false;

  static const primary = Color(0xFF00683C);
  static const primaryContainer = Color(0xFF18834F);
  static const onPrimaryContainer = Color(0xFFE9FFEC);
  static const secondary = Color(0xFF006B5F);
  static const secondaryContainer = Color(0xFF9BEFE0);
  static const onSecondaryContainer = Color(0xFF066F63);
  static const tertiary = Color(0xFF00665C);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const teal066 = Color(0xFF066F63);

  static Color get background =>
      isDark ? const Color(0xFF071814) : const Color(0xFFF4F8F6);

  static Color get surface =>
      isDark ? const Color(0xFF10231E) : const Color(0xFFF3FAFF);

  static Color get surfaceContainerLowest =>
      isDark ? const Color(0xFF142B25) : const Color(0xFFFFFFFF);

  static Color get surfaceContainerLow =>
      isDark ? const Color(0xFF18352D) : const Color(0xFFECF5FA);

  static Color get surfaceContainerHigh =>
      isDark ? const Color(0xFF1B3B32) : const Color(0xFFE0EAEF);

  static Color get surfaceContainer =>
      isDark ? const Color(0xFF10231E) : const Color(0xFFE6EFF5);

  static Color get surfaceVariant =>
      isDark ? const Color(0xFF24433A) : const Color(0xFFDAE4E9);

  static Color get onSurface =>
      isDark ? const Color(0xFFEAF5F0) : const Color(0xFF141D21);

  static Color get onSurfaceVariant =>
      isDark ? const Color(0xFFA9BDB4) : const Color(0xFF3E4941);

  static Color get outline =>
      isDark ? const Color(0xFF7FA295) : const Color(0xFF6E7A70);

  static Color get outlineVariant =>
      isDark ? const Color(0xFF24433A) : const Color(0xFFBECABE);

  static Color get cardBorder =>
      isDark ? const Color(0xFF24433A) : const Color(0xFFD4E5DE);
}

// ─── Home Screen ──────────────────────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  Future<void> _goToPostMaterialScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PostMaterialScreen(),
      ),
    );

    if (!mounted) return;

    if (result != null && result is Map && result['posted'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${result['title']} listing posted successfully. Waiting for receiver.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.deepTeal,
        ),
      );
    }
  }


  // Count-up controllers
  late AnimationController _countController;
  late Animation<double> _kgAnimation;
  late Animation<double> _pointsAnimation;
  late Animation<double> _pickupsAnimation;
  late Animation<double> _mealsAnimation;

  // Glow/breathing controller
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Shimmer controller
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Pulse controller for notification dot
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Count-up
    _countController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _kgAnimation =
        Tween<double>(begin: 0, end: 120).animate(CurvedAnimation(
          parent: _countController,
          curve: Curves.easeOut,
        ));
    _pointsAnimation =
        Tween<double>(begin: 0, end: 850).animate(CurvedAnimation(
          parent: _countController,
          curve: Curves.easeOut,
        ));
    _pickupsAnimation =
        Tween<double>(begin: 0, end: 18).animate(CurvedAnimation(
          parent: _countController,
          curve: Curves.easeOut,
        ));
    _mealsAnimation =
        Tween<double>(begin: 0, end: 240).animate(CurvedAnimation(
          parent: _countController,
          curve: Curves.easeOut,
        ));

    // Glow breathing
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Shimmer
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _shimmerAnimation =
        Tween<double>(begin: -1.0, end: 2.0).animate(_shimmerController);

    // Pulse dot
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 2.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _countController.forward();
  }

  @override
  void dispose() {
    _countController.dispose();
    _glowController.dispose();
    _shimmerController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _HomeColors.isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _HomeColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Floating leaf particles
            ..._buildLeaves(),
            Column(
              children: [
                _buildTopAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildImpactSection(),
                        const SizedBox(height: 24),
                        _buildMainCTA(),
                        const SizedBox(height: 24),
                        _buildIncomingRequest(),
                        const SizedBox(height: 24),
                        _buildActiveListings(),
                        const SizedBox(height: 24),
                        _buildPickupVerification(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─── Floating Leaf Particles ───────────────────────────────────────────────
  List<Widget> _buildLeaves() {
    return [
      _FloatingLeaf(
        top: 80,
        left: MediaQuery.of(context).size.width * 0.1,
        size: 24,
        color: _HomeColors.primary.withOpacity(0.08),
        duration: 25,
        delay: 0,
      ),
      _FloatingLeaf(
        top: MediaQuery.of(context).size.height * 0.35,
        right: MediaQuery.of(context).size.width * 0.12,
        size: 18,
        color: _HomeColors.secondary.withOpacity(0.08),
        duration: 30,
        delay: 5,
      ),
      _FloatingLeaf(
        top: MediaQuery.of(context).size.height * 0.65,
        left: MediaQuery.of(context).size.width * 0.18,
        size: 22,
        color: _HomeColors.primaryContainer.withOpacity(0.08),
        duration: 35,
        delay: 12,
      ),
    ];
  }

  // ─── Top App Bar ───────────────────────────────────────────────────────────
  Widget _buildTopAppBar() {
    return Container(
      color: _HomeColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _HomeColors.outlineVariant),
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDqm8e5NszwOHEmC9FlF337ngGkViuYGXPKA7nHRl4EovjMVHlgJ2AKJ59oo0is6waaCrueMmkyqsBA5miK_tVhKrhWs8VOR28WRbtgwJJh-HCwuThFjWd70jszrTUkUWrIY_mzBUchHsuM5wuiSZ0-C1nvsnvPIKA7Yv06_RNuhMy4nVEGtXZJobEuRYnEQ4fMAusw_WiP_jB3UbyFU8C29n904H8goGOAGf-0kzUMuoKnfNSeoFYeTjrTwZ0_X_0jqmYGbhuiZq8',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.store, color: _HomeColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontFamily: 'Hanken Grotesk',
                    fontSize: 12,
                    letterSpacing: 0.05 * 12,
                    fontWeight: FontWeight.w600,
                    color: _HomeColors.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
                Text(
                  'Green Bites Restaurant',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: _HomeColors.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _HomeColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    'SILVER IMPACT PARTNER',
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _HomeColors.onSecondaryContainer,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: ThemeController.toggleTheme,
            icon: Icon(
              Icons.dark_mode_rounded,
              color: AppColors.primaryGreen,
            ),
          ),
          // Notification bell
          GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.notifications_outlined,
                      color: _HomeColors.onSurface),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (_, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 8 * _pulseAnimation.value,
                              height: 8 * _pulseAnimation.value,
                              decoration: BoxDecoration(
                                color: _HomeColors.error.withOpacity(
                                    1.0 - (_pulseAnimation.value - 0.8) / 1.7),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _HomeColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Impact Section ────────────────────────────────────────────────────────
  Widget _buildImpactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Recovery Impact",
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _HomeColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _countController,
          builder: (_, __) {
            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _StatCard(
                  icon: Icons.monitor_weight_outlined,
                  value: '${_kgAnimation.value.ceil()} kg',
                  label: 'Kg Diverted',
                ),
                _StatCard(
                  icon: Icons.star_outline,
                  value: '${_pointsAnimation.value.ceil()}',
                  label: 'Impact Points',
                ),
                _StatCard(
                  icon: Icons.check_circle_outline,
                  value: '${_pickupsAnimation.value.ceil()}',
                  label: 'Verified Pickups',
                ),
                _StatCard(
                  icon: Icons.restaurant_outlined,
                  value: '${_mealsAnimation.value.ceil()}',
                  label: 'Meals Supported',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ─── Main CTA ──────────────────────────────────────────────────────────────
  Widget _buildMainCTA() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (_, child) {
        return GestureDetector(
          onTap: _goToPostMaterialScreen,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF18834F), Color(0xFF04998B)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _HomeColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Shimmer overlay
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(
                          _shimmerAnimation.value *
                              MediaQuery.of(context).size.width,
                          0),
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.photo_camera,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Post Material',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Upload a photo and let AI classify it',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 13,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward, color: Colors.white),
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

  // ─── Incoming Request ──────────────────────────────────────────────────────
  Widget _buildIncomingRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Incoming Request',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _HomeColors.onSurface,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _HomeColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _HomeColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _HomeColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: _HomeColors.primaryContainer.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Charity logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _HomeColors.surfaceContainer,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDTkD-xwQAxs9IVkPKQ4ztcvocsOnxbJ8k1SiB1PcyU5X7YXorfXqPcR0PKsPvSsatjSPf4J9Ihe6Z4GJnWY9Wa-92QHOVhYLKfrs1WtKsajM7wm4zNV-eHxuIiBjVjhIr-0uvvUkmQb5UDeb8T-WJositdu8cN5a8Iv5SsoSbjpJlRiZr7EVk1x0WSsurxVZvmQYZ20fdOVp8xCZnGElVUj1ZvQJvTtkjNb06SRr-FDthvyZThejMC4UGKPBmGu0nbVz2KoL6yNKM',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.volunteer_activism, color: _HomeColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hope Charity requested surplus food',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _HomeColors.onSurface,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pickup: Today, 6:00 PM • 2.4 km away',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            color: _HomeColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => HapticFeedback.lightImpact(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _HomeColors.error, width: 2),
                        foregroundColor: _HomeColors.error,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        'Reject',
                        style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => HapticFeedback.mediumImpact(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _HomeColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Accept',
                        style: TextStyle(
                            fontFamily: 'Hanken Grotesk',
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Active Listings ───────────────────────────────────────────────────────
  Widget _buildActiveListings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Listings',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _HomeColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _ListingCard(
          title: '10 kg Surplus Food',
          statusIcon: Icons.check_circle_outline,
          statusText: 'Pickup accepted',
          statusColor: _HomeColors.primary,
          badgeText: 'HIGH URGENCY',
          badgeColor: _HomeColors.errorContainer,
          badgeTextColor: _HomeColors.onErrorContainer,
          receiverName: 'Hope Charity',
          receiverImageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCPaztDnYbsV53k_QYkAso6PmzS9_eh73vvxFO5h2AMWpkCJzzZzYxmX4-Y__G33Q9hfYOu5wGci9vg77se1dmacbB-OUkndoychgMN0EGRjPXgA_Csbp9mVNeAnYkbV-BgsGfYP9dA0ei0JORuPPDYrP3fb1geNiaPf0f8T4lAlAZQhz45e5f7bHBAfKsBhaFweIi8X73rnSfW60jVJGZiitxVahJBoGwj7cxPQj6_6t-Lv336jDO_2yaE6G_BaDgkDNBxyg-KGo8',
          points: '80 expected points',
          dimBottom: false,
        ),
        const SizedBox(height: 16),
        _ListingCard(
          title: 'Cardboard Boxes',
          statusIcon: Icons.hourglass_empty,
          statusText: 'Waiting for receiver',
          statusColor: _HomeColors.outline,
          badgeText: 'FLEXIBLE PICKUP',
          badgeColor: _HomeColors.surfaceContainer,
          badgeTextColor: _HomeColors.onSurfaceVariant,
          receiverName: 'No receiver yet',
          receiverImageUrl: null,
          points: '45 expected points',
          dimBottom: true,
        ),
      ],
    );
  }

  // ─── Pickup Verification ───────────────────────────────────────────────────
  Widget _buildPickupVerification() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (_, child) {
        return Container(
          decoration: BoxDecoration(
            color: _HomeColors.teal066,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _HomeColors.teal066.withOpacity(_glowAnimation.value),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // Background QR icon
              Positioned(
                top: -4,
                right: -4,
                child: Icon(
                  Icons.qr_code_2,
                  size: 80,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UPCOMING MILESTONE',
                    style: TextStyle(
                      fontFamily: 'Hanken Grotesk',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pickup scheduled',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hope Charity is arriving today at 6:00 PM. Have your verification code ready.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => HapticFeedback.mediumImpact(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.qr_code_2, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Code',
                            style: TextStyle(
                              fontFamily: 'Hanken Grotesk',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Bottom Nav ────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    const navItems = [
      _NavItem(icon: Icons.home, label: 'Home'),
      _NavItem(icon: Icons.add_circle_outline, label: 'Post'),
      _NavItem(icon: Icons.format_list_bulleted, label: 'Listings'),
      _NavItem(icon: Icons.eco_outlined, label: 'Impact'),
      _NavItem(icon: Icons.person_outline, label: 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _HomeColors.surfaceContainerLowest,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: _HomeColors.primaryContainer.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (i) {
              final selected = _selectedIndex == i;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();

                  if (i == 1) {
                    _goToPostMaterialScreen();
                    return;
                  }

                  if (i == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ListingsScreen(),
                      ),
                    );
                    return;
                  }

                  setState(() => _selectedIndex = i);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.elasticOut,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected
                            ? _filledIcon(navItems[i].icon)
                            : navItems[i].icon,
                        color: selected
                            ? _HomeColors.primary
                            : _HomeColors.onSurfaceVariant,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        navItems[i].label,
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: selected
                              ? _HomeColors.primary
                              : _HomeColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _filledIcon(IconData icon) {
    // Return filled variants for common icons
    if (icon == Icons.home) return Icons.home;
    if (icon == Icons.person_outline) return Icons.person;
    if (icon == Icons.eco_outlined) return Icons.eco;
    return icon;
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────
class _StatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1, end: 0.96).animate(_scaleCtrl);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleCtrl.forward(),
      onTapUp: (_) => _scaleCtrl.reverse(),
      onTapCancel: () => _scaleCtrl.reverse(),
      onTap: () => HapticFeedback.lightImpact(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _HomeColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _HomeColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: _HomeColors.primaryContainer.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(widget.icon, color: _HomeColors.primary, size: 22),
              const SizedBox(height: 8),
              Text(
                widget.value,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _HomeColors.primaryContainer,
                ),
              ),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Hanken Grotesk',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.6,
                  color: _HomeColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Listing Card ─────────────────────────────────────────────────────────
class _ListingCard extends StatefulWidget {
  final String title;
  final IconData statusIcon;
  final String statusText;
  final Color statusColor;
  final String badgeText;
  final Color badgeColor;
  final Color badgeTextColor;
  final String receiverName;
  final String? receiverImageUrl;
  final String points;
  final bool dimBottom;

  const _ListingCard({
    required this.title,
    required this.statusIcon,
    required this.statusText,
    required this.statusColor,
    required this.badgeText,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.receiverName,
    this.receiverImageUrl,
    required this.points,
    required this.dimBottom,
  });

  @override
  State<_ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<_ListingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween<double>(begin: 1, end: 0.97).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      onTap: () => HapticFeedback.lightImpact(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _HomeColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _HomeColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: _HomeColors.primaryContainer.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _HomeColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(widget.statusIcon,
                                color: widget.statusColor, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              widget.statusText,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                color: widget.statusColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: widget.badgeColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      widget.badgeText,
                      style: TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: widget.badgeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              // Divider + footer
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Divider(
                    height: 1, color: _HomeColors.surfaceVariant),
              ),
              const SizedBox(height: 12),
              Opacity(
                opacity: widget.dimBottom ? 0.6 : 1.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (widget.receiverImageUrl != null) ...[
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _HomeColors.surfaceContainer,
                            ),
                            child: ClipOval(
                              child: Image.network(
                                widget.receiverImageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                    Icons.person,
                                    size: 16,
                                    color: _HomeColors.outline),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.receiverName,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            fontStyle: widget.receiverImageUrl == null
                                ? FontStyle.italic
                                : FontStyle.normal,
                            color: _HomeColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.points,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _HomeColors.onSecondaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Nav Item Data ─────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

// ─── Floating Leaf ─────────────────────────────────────────────────────────
class _FloatingLeaf extends StatefulWidget {
  final double? top;
  final double? left;
  final double? right;
  final double size;
  final Color color;
  final int duration;
  final int delay;

  const _FloatingLeaf({
    this.top,
    this.left,
    this.right,
    required this.size,
    required this.color,
    required this.duration,
    required this.delay,
  });

  @override
  State<_FloatingLeaf> createState() => _FloatingLeafState();
}

class _FloatingLeafState extends State<_FloatingLeaf>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _translateY;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );
    _translateY = Tween<double>(begin: 0, end: 120).animate(_ctrl);
    _rotate = Tween<double>(begin: 0, end: 2 * pi).animate(_ctrl);

    Future.delayed(Duration(seconds: widget.delay), () {
      if (mounted) _ctrl.repeat();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      right: widget.right,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            return Transform.translate(
              offset: Offset(0, _translateY.value),
              child: Transform.rotate(
                angle: _rotate.value,
                child: Icon(
                  Icons.eco,
                  size: widget.size,
                  color: widget.color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
