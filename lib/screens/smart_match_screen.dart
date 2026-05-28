import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class SmartMatchScreen extends StatelessWidget {
  final String materialTitle;
  final String materialType;
  final String receiverName;
  final String distance;
  final String pickupTime;
  final String points;

  const SmartMatchScreen({
    super.key,
    required this.materialTitle,
    required this.materialType,
    required this.receiverName,
    required this.distance,
    required this.pickupTime,
    required this.points,
  });

  bool _isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color _bg(BuildContext context) {
    return _isDark(context) ? const Color(0xFF071814) : AppColors.softBackground;
  }

  Color _card(BuildContext context) {
    return _isDark(context) ? const Color(0xFF142B25) : AppColors.white;
  }

  Color _surface(BuildContext context) {
    return _isDark(context) ? const Color(0xFF10231E) : AppColors.white;
  }

  Color _text(BuildContext context) {
    return _isDark(context) ? const Color(0xFFEAF5F0) : AppColors.charcoal;
  }

  Color _muted(BuildContext context) {
    return _isDark(context)
        ? const Color(0xFFA9BDB4)
        : AppColors.charcoal.withOpacity(0.58);
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
          'Smart Match',
          style: TextStyle(
            color: _text(context),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(context),
            const SizedBox(height: 20),
            _buildMatchScoreCard(context),
            const SizedBox(height: 18),
            _buildReceiverCard(context),
            const SizedBox(height: 18),
            _buildWhyMatchedCard(context),
            const SizedBox(height: 18),
            _buildRecoveryPlanCard(context),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
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
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -18,
            top: -18,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white.withOpacity(0.12),
              size: 120,
            ),
          ),
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.psychology_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI found the best recovery match',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Based on material type, urgency, distance, and partner reliability.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
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

  Widget _buildMatchScoreCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(_isDark(context) ? 0.04 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 86,
            width: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 0.94,
                  strokeWidth: 8,
                  backgroundColor: _border(context),
                  color: AppColors.primaryGreen,
                ),
                Text(
                  '94%',
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
                  'Match Confidence',
                  style: TextStyle(
                    color: _text(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'This partner is highly suitable for recovering this material.',
                  style: TextStyle(
                    color: _muted(context),
                    fontSize: 13.2,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 31,
                backgroundColor: AppColors.brightTeal.withOpacity(0.14),
                child: Icon(
                  Icons.volunteer_activism_rounded,
                  color: AppColors.deepTeal,
                  size: 32,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiverName,
                      style: TextStyle(
                        color: _text(context),
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Verified recovery partner',
                      style: TextStyle(
                        color: _muted(context),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.freshGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Verified',
                  style: TextStyle(
                    color: AppColors.freshGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  context,
                  icon: Icons.location_on_rounded,
                  label: 'Distance',
                  value: distance,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniStat(
                  context,
                  icon: Icons.schedule_rounded,
                  label: 'Pickup',
                  value: pickupTime,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(
      BuildContext context, {
        required IconData icon,
        required String label,
        required String value,
      }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 21,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: _muted(context),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              color: _text(context),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhyMatchedCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _card(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            context,
            icon: Icons.rule_rounded,
            title: 'Why this match?',
          ),
          const SizedBox(height: 16),
          _reasonRow(context, 'Accepts $materialType recovery requests'),
          _reasonRow(context, 'Available within the selected pickup window'),
          _reasonRow(context, 'Nearby partner: $distance'),
          _reasonRow(context, 'High reliability score: 94%'),
          _reasonRow(context, 'Suitable for urgent edible surplus recovery'),
        ],
      ),
    );
  }

  Widget _reasonRow(BuildContext context, String textValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.freshGreen,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              textValue,
              style: TextStyle(
                color: _text(context),
                fontSize: 13.5,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryPlanCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            context,
            icon: Icons.route_rounded,
            title: 'Suggested Recovery Plan',
            forceWhite: true,
          ),
          const SizedBox(height: 16),
          _planStep(
            number: '1',
            title: 'Confirm the request',
            subtitle: 'Approve the receiver and lock the pickup window.',
          ),
          _planStep(
            number: '2',
            title: 'Prepare material',
            subtitle: 'Keep the $materialTitle ready and separated.',
          ),
          _planStep(
            number: '3',
            title: 'Verify pickup',
            subtitle: 'Use the pickup code to confirm handover and activate points.',
          ),
        ],
      ),
    );
  }

  Widget _planStep({
    required String number,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: 12.5,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              side: BorderSide(
                color: AppColors.primaryGreen.withOpacity(0.5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Review Later',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$receiverName Offer sent. Waiting for Response.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.deepTeal,
                ),
              );

              Navigator.pop(context, {
                'offerSent': true,
                'receiverName': receiverName,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Send Offer',
              style: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardTitle(
      BuildContext context, {
        required IconData icon,
        required String title,
        bool forceWhite = false,
      }) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: forceWhite
                ? Colors.white.withOpacity(0.13)
                : AppColors.primaryGreen.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: forceWhite ? Colors.white : AppColors.primaryGreen,
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: forceWhite ? Colors.white : _text(context),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}