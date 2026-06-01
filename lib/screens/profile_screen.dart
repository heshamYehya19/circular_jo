import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/theme_controller.dart';
import 'impact_record_screen.dart';
import 'listings_screen.dart';
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
            _buildOrganizationCard(context),
            const SizedBox(height: 18),
            _buildImpactBadgeCard(context),
            const SizedBox(height: 18),
            _buildVerificationDetails(context),
            const SizedBox(height: 18),
            _buildAccountDetails(context),
            const SizedBox(height: 18),
            _buildSettings(context),
            const SizedBox(height: 22),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizationCard(BuildContext context) {
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
        borderRadius: BorderRadius.circular(28),
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
            right: -20,
            top: -20,
            child: Icon(
              Icons.storefront_rounded,
              size: 125,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Row(
            children: [
              Container(
                height: 68,
                width: 68,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.18),
                  ),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Green Bites Restaurant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Verified Organization',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 9),
                    _ProfileBadge(
                      text: 'Silver Tier',
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

  Widget _buildImpactBadgeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _border(context)),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 88,
            width: 88,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.72,
                  strokeWidth: 8,
                  backgroundColor: _border(context),
                  color: AppColors.primaryGreen,
                ),
                Text(
                  '72%',
                  style: TextStyle(
                    color: _text(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '8,650 Impact Points',
                  style: TextStyle(
                    color: _text(context),
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '350 points away from Gold Tier.',
                  style: TextStyle(
                    color: _muted(context),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PointSystemScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'View Point System',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
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

  Widget _buildVerificationDetails(BuildContext context) {
    return _sectionCard(
      context,
      title: 'Organization Verification',
      icon: Icons.verified_user_rounded,
      child: Column(
        children: [
          _infoRow(context, 'National Number', '100200300'),
          _infoRow(context, 'Organization Type', 'Restaurant'),
          _infoRow(context, 'Status', 'Active - Verified'),
          _infoRow(context, 'Source', 'CCD Mock Verification', isLast: true),
        ],
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context) {
    return _sectionCard(
      context,
      title: 'Account Details',
      icon: Icons.person_rounded,
      child: Column(
        children: [
          _infoRow(context, 'Account Holder', 'Circular JO User'),
          _infoRow(context, 'Phone Number', '+962 7X XXX XXXX'),
          _infoRow(context, 'Email', 'user@organization.jo', isLast: true),
        ],
      ),
    );
  }



  Widget _buildSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return _sectionCard(
      context,
      title: 'App Settings',
      icon: Icons.settings_rounded,
      child: Column(
        children: [
          _settingsTile(
            context,
            icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            title: 'Dark Mode',
            trailing: Switch(
              value: isDark,
              activeColor: AppColors.primaryGreen,
              onChanged: (_) {
                HapticFeedback.selectionClick();
                ThemeController.toggleTheme();
              },
            ),
          ),
          _settingsTile(
            context,
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            trailing: Switch(
              value: true,
              activeColor: AppColors.primaryGreen,
              onChanged: (_) {
                _showMessage(context, 'Notifications setting updated.');
              },
            ),
          ),
          _settingsTile(
            context,
            icon: Icons.language_rounded,
            title: 'Language',
            trailing: Text(
              'English',
              style: TextStyle(
                color: _muted(context),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            isLast: true,
          ),
        ],
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

  Widget _sectionCard(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Widget child,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: _border(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryGreen,
                  size: 23,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _text(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(
      BuildContext context,
      String label,
      String value, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 42,
            child: Text(
              label,
              style: TextStyle(
                color: _muted(context),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 58,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _text(context),
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required VoidCallback onTap,
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardSoft(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border(context)),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: _text(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: _muted(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: _muted(context),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Widget trailing,
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _cardSoft(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _border(context)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: _text(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
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

class _ProfileBadge extends StatelessWidget {
  final String text;

  const _ProfileBadge({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}