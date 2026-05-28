import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class PickupVerificationScreen extends StatefulWidget {
  final String materialTitle;
  final String receiverName;
  final String pickupTime;
  final String points;

  const PickupVerificationScreen({
    super.key,
    required this.materialTitle,
    required this.receiverName,
    required this.pickupTime,
    required this.points,
  });

  @override
  State<PickupVerificationScreen> createState() =>
      _PickupVerificationScreenState();
}

class _PickupVerificationScreenState extends State<PickupVerificationScreen> {
  bool handoverConfirmed = false;
  bool proofUploaded = false;
  bool pickupVerified = false;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg => isDark ? const Color(0xFF071814) : AppColors.softBackground;
  Color get card => isDark ? const Color(0xFF142B25) : AppColors.white;
  Color get surface => isDark ? const Color(0xFF10231E) : AppColors.white;
  Color get text => isDark ? const Color(0xFFEAF5F0) : AppColors.charcoal;
  Color get muted =>
      isDark ? const Color(0xFFA9BDB4) : AppColors.charcoal.withOpacity(0.58);
  Color get border => isDark ? const Color(0xFF24433A) : AppColors.mintBorder;

  void _confirmHandover() {
    HapticFeedback.mediumImpact();

    setState(() {
      handoverConfirmed = true;
    });

    _showMessage('Handover confirmed. Points are now pending verification.');
  }

  void _uploadProof() {
    HapticFeedback.mediumImpact();

    setState(() {
      proofUploaded = true;
    });

    _showMessage('Proof photo uploaded for final confirmation.');
  }

  void _verifyPickup() {
    if (!handoverConfirmed) {
      _showMessage('Confirm handover first.');
      return;
    }

    if (!proofUploaded) {
      _showMessage('Upload proof photo before final verification.');
      return;
    }

    HapticFeedback.heavyImpact();

    setState(() {
      pickupVerified = true;
    });

    _showMessage('${widget.points} points awarded successfully.');
  }

  void _finish() {
    Navigator.pop(context, {
      'verified': pickupVerified,
      'points': widget.points,
      'material': widget.materialTitle,
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: text,
        title: Text(
          'Pickup Verification',
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroCard(),
            const SizedBox(height: 18),
            _buildMaterialSummary(),
            const SizedBox(height: 18),
            _buildPickupCodeCard(),
            const SizedBox(height: 18),
            _buildVerificationSteps(),
            const SizedBox(height: 18),
            _buildActionButtons(),
            const SizedBox(height: 18),
            if (pickupVerified) _buildSuccessCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
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
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.verified_rounded,
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
                  'Verify real pickup',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Confirm the handover before points become official.',
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
    );
  }

  Widget _buildMaterialSummary() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            icon: Icons.inventory_2_rounded,
            title: 'Pickup Summary',
          ),
          const SizedBox(height: 16),
          _summaryRow('Material', widget.materialTitle),
          _summaryRow('Receiver', widget.receiverName),
          _summaryRow('Pickup Time', widget.pickupTime),
          _summaryRow('Expected Points', widget.points),
          _summaryRow(
            'Status',
            pickupVerified
                ? 'Verified completed'
                : handoverConfirmed
                ? 'Pending final proof'
                : 'Waiting for handover',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 38,
            child: Text(
              label,
              style: TextStyle(
                color: muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 62,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: text,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickupCodeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepTeal,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepTeal.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'One-Time Pickup Code',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.18)),
            ),
            child: const Text(
              'CJ-4829',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                letterSpacing: 3,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Icon(
            Icons.qr_code_2_rounded,
            color: Colors.white.withOpacity(0.92),
            size: 110,
          ),
          const SizedBox(height: 10),
          Text(
            'Receiver enters this code to confirm physical pickup.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.70),
              fontSize: 12.5,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationSteps() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardTitle(
            icon: Icons.timeline_rounded,
            title: 'Verification Flow',
          ),
          const SizedBox(height: 18),
          _stepTile(
            number: '1',
            title: 'Pickup code shared',
            subtitle: 'The receiver uses the one-time code at pickup.',
            done: true,
          ),
          _stepTile(
            number: '2',
            title: 'Handover confirmed',
            subtitle: 'Supplier confirms the material was handed over.',
            done: handoverConfirmed,
          ),
          _stepTile(
            number: '3',
            title: 'Proof uploaded',
            subtitle: 'Receiver/final side uploads proof of received material.',
            done: proofUploaded,
          ),
          _stepTile(
            number: '4',
            title: 'Points verified',
            subtitle: 'Pending points become official impact points.',
            done: pickupVerified,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _stepTile({
    required String number,
    required String title,
    required String subtitle,
    required bool done,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: done ? AppColors.primaryGreen : surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: done ? AppColors.primaryGreen : border,
                ),
              ),
              child: Center(
                child: done
                    ? const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 19,
                )
                    : Text(
                  number,
                  style: TextStyle(
                    color: muted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Container(
                height: 46,
                width: 2,
                color: done ? AppColors.primaryGreen : border,
              ),
          ],
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: text,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: muted,
                    fontSize: 12.5,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: handoverConfirmed ? null : _confirmHandover,
                icon: const Icon(Icons.handshake_rounded),
                label: const Text('Confirm Handover'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: BorderSide(
                    color: AppColors.primaryGreen.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: proofUploaded ? null : _uploadProof,
                icon: const Icon(Icons.add_a_photo_rounded),
                label: const Text('Upload Proof'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.deepTeal,
                  side: BorderSide(
                    color: AppColors.deepTeal.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: pickupVerified ? _finish : _verifyPickup,
            icon: Icon(
              pickupVerified
                  ? Icons.arrow_back_rounded
                  : Icons.verified_rounded,
            ),
            label: Text(
              pickupVerified ? 'Back to Listings' : 'Verify Pickup',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.freshGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.freshGreen.withOpacity(0.42),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.freshGreen,
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Pickup verified. ${widget.points} points have been added to the organization impact record.',
              style: TextStyle(
                color: text,
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryGreen,
            size: 22,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}