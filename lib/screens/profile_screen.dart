import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/demo_app_state.dart';
import '../constants/app_colors.dart';
import '../constants/theme_controller.dart';
import 'point_system_screen.dart';
import 'signup_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _bg(BuildContext context) {
    return _isDark(context) ? const Color(0xFF081A16) : AppColors.softBackground;
  }

  Color _card(BuildContext context) {
    return _isDark(context) ? const Color(0xFF122823) : AppColors.white;
  }

  Color _cardSoft(BuildContext context) {
    return _isDark(context) ? const Color(0xFF0F221E) : const Color(0xFFF7FBF9);
  }

  Color _text(BuildContext context) {
    return _isDark(context) ? const Color(0xFFEAF6F0) : AppColors.charcoal;
  }

  Color _muted(BuildContext context) {
    return _isDark(context)
        ? const Color(0xFFA9BDB4)
        : AppColors.charcoal.withOpacity(0.60);
  }

  Color _border(BuildContext context) {
    return _isDark(context) ? const Color(0xFF24433A) : AppColors.mintBorder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg(context),
      appBar: AppBar(
        backgroundColor: _bg(context),
        elevation: 0,
        foregroundColor: _text(context),
        title: Text(
          'Profile',
          style: TextStyle(
            color: _text(context),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildStatsRow(context),
            const SizedBox(height: 18),
            _buildIncentiveCard(context),
            const SizedBox(height: 18),
            _buildSection(
              context,
              title: 'Organization',
              children: [
                _profileTile(
                  context,
                  icon: Icons.verified_user_rounded,
                  title: 'Verification details',
                  subtitle: 'Active • CCD Mock Verification',
                  trailing: _statusPill(context, 'Verified'),
                  onTap: () => _showDetailsSheet(context),
                ),

                _divider(context),

                ValueListenableBuilder<String>(
                  valueListenable: DemoAppState.organizationNationalNumber,
                  builder: (context, nationalNumber, _) {
                    return _profileTile(
                      context,
                      icon: Icons.badge_rounded,
                      title: 'National number',
                      subtitle: nationalNumber,
                      trailing: Icon(
                        Icons.copy_rounded,
                        color: _muted(context),
                        size: 19,
                      ),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showMessage(context, 'National number copied.');
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildSection(
              context,
              title: 'Account',
              children: [
                _profileTile(
                  context,
                  icon: Icons.person_rounded,
                  title: 'Account holder',
                  subtitle: 'Circular JO User',
                  trailing: null,
                ),
                _divider(context),
                _profileTile(
                  context,
                  icon: Icons.email_rounded,
                  title: 'Email',
                  subtitle: 'user@organization.jo',
                  trailing: null,
                ),
                _divider(context),
                _profileTile(
                  context,
                  icon: Icons.phone_rounded,
                  title: 'Phone',
                  subtitle: '+962 7X XXX XXXX',
                  trailing: null,
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildSection(
              context,
              title: 'Preferences',
              children: [
                _settingsTile(
                  context,
                  icon: _isDark(context)
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  subtitle: _isDark(context) ? 'Enabled' : 'Disabled',
                  trailing: Switch(
                    value: _isDark(context),
                    activeColor: AppColors.primaryGreen,
                    onChanged: (_) {
                      HapticFeedback.selectionClick();
                      ThemeController.toggleTheme();
                    },
                  ),
                ),
                _divider(context),
                _settingsTile(
                  context,
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  subtitle: 'Pickup and offer alerts',
                  trailing: Switch(
                    value: true,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (_) {
                      HapticFeedback.selectionClick();
                      _showMessage(context, 'Notifications setting updated.');
                    },
                  ),
                ),
                _divider(context),
                _profileTile(
                  context,
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English',
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _muted(context),
                    size: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _buildSection(
              context,
              title: 'Circular JO',
              children: [
                _profileTile(
                  context,
                  icon: Icons.stars_rounded,
                  title: 'Point system',
                  subtitle: 'View tiers and earning rules',
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _muted(context),
                    size: 15,
                  ),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PointSystemScreen(),
                      ),
                    );
                  },
                ),
                _divider(context),
                _profileTile(
                  context,
                  icon: Icons.policy_rounded,
                  title: 'Verification policy',
                  subtitle: 'Points require verified pickup',
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: _muted(context),
                    size: 15,
                  ),
                  onTap: () => _showVerificationPolicy(context),
                ),
              ],
            ),
            const SizedBox(height: 22),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            color: AppColors.primaryGreen.withOpacity(0.22),
            blurRadius: 22,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -22,
            top: -25,
            child: Icon(
              Icons.storefront_rounded,
              size: 130,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 74,
                    width: 74,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.18),
                      ),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: DemoAppState.organizationName,
                          builder: (context, orgName, _) {
                            return Text(
                              orgName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Verified Organization',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _headerPill(
                    icon: Icons.verified_rounded,
                    text: 'Verified',
                  ),
                  const SizedBox(width: 10),
                  _headerPill(
                    icon: Icons.workspace_premium_rounded,
                    text: 'Silver Tier',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerPill({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border(context)),
      ),
      child: Row(
        children: [
          _statItem(context, '3', 'Listings'),
          _verticalDivider(context),
          _statItem(context, '74', 'Pickups'),
          _verticalDivider(context),
          _statItem(context, '8,650', 'Points'),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: _text(context),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: _muted(context),
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: _border(context),
    );
  }

  Widget _buildIncentiveCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(
              _isDark(context) ? 0.04 : 0.08,
            ),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primaryGreen,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Incentive Readiness',
                      style: TextStyle(
                        color: _text(context),
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Ready for official review',
                      style: TextStyle(
                        color: _muted(context),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _statusPill(context, 'Ready'),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Generate a verified impact report that can support future sustainability incentive or tax-benefit applications.',
            style: TextStyle(
              color: _muted(context),
              fontSize: 12.7,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showMessage(
                  context,
                  'Verified incentive report generated for review.',
                );
              },
              icon: const Icon(Icons.description_rounded, size: 19),
              label: const Text('Generate Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Circular JO provides verified records for official review. It does not approve exemptions directly.',
            style: TextStyle(
              color: _muted(context),
              fontSize: 10.8,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
            child: Text(
              title,
              style: TextStyle(
                color: _muted(context),
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _profileTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget? trailing,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap == null
          ? null
          : () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.11),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 22,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _text(context),
                      fontSize: 14.3,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: _muted(context),
                      fontSize: 12.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 10),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  Widget _settingsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Widget trailing,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.11),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _text(context),
                    fontSize: 14.3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: _muted(context),
                    fontSize: 12.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _statusPill(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.freshGreen.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.freshGreen,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _divider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 73),
      child: Divider(
        height: 1,
        color: _border(context),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.mediumImpact();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const SignUpPage(),
            ),
                (_) => false,
          );
        },
        icon: const Icon(Icons.logout_rounded),
        label: const Text('Log Out'),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.redAccent,
          side: BorderSide(
            color: Colors.redAccent.withOpacity(0.45),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
    );
  }

  void _showDetailsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: _border(context),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 22),
              Icon(
                Icons.verified_user_rounded,
                color: AppColors.primaryGreen,
                size: 44,
              ),
              const SizedBox(height: 12),
              Text(
                'Verified Organization',
                style: TextStyle(
                  color: _text(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${DemoAppState.organizationName.value} was verified using a mock company national number for prototype demonstration.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted(context),
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVerificationPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _card(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: _border(context),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 22),
              Icon(
                Icons.policy_rounded,
                color: AppColors.primaryGreen,
                size: 44,
              ),
              const SizedBox(height: 12),
              Text(
                'Verification Policy',
                style: TextStyle(
                  color: _text(context),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Circular JO only awards official impact points after a pickup is verified through code confirmation and proof of handover.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _muted(context),
                  fontSize: 13,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepTeal,
      ),
    );
  }
}