import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

import 'smart_match_screen.dart';

import 'pickup_verification_screen.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  int selectedFilter = 0;
  bool cardboardOfferSent = false;
  bool organicOfferSent = false;

  final filters = [
    'All',
    'Waiting',
    'Matched',
    'Pickup',
    'Verified',
  ];

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get bg => isDark ? const Color(0xFF071814) : AppColors.softBackground;
  Color get card => isDark ? const Color(0xFF142B25) : AppColors.white;
  Color get surface => isDark ? const Color(0xFF10231E) : AppColors.white;
  Color get text => isDark ? const Color(0xFFEAF5F0) : AppColors.charcoal;
  Color get muted =>
      isDark ? const Color(0xFFA9BDB4) : AppColors.charcoal.withOpacity(0.58);
  Color get border => isDark ? const Color(0xFF24433A) : AppColors.mintBorder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: text,
        title: Text(
          'Listings',
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 18),
            _buildFilterChips(),
            const SizedBox(height: 20),
            _buildListingCard(
              title: '10 kg Surplus Food',
              category: 'Surplus Food',
              status: 'Pickup accepted',
              receiver: 'Hope Charity',
              pickupTime: 'Today, 6:00 PM',
              distance: '2.4 km away',
              points: '80',
              urgency: 'High urgency',
              urgencyColor: Colors.orangeAccent,
              icon: Icons.restaurant_rounded,
              progressStep: 3,
              showMatchButton: true,
              showCodeButton: true,
            ),
            const SizedBox(height: 16),
            _buildListingCard(
              title: 'Cardboard Boxes',
              category: 'Recyclable Material',
              status: cardboardOfferSent ? 'Offer sent' : 'Waiting for receiver',
              receiver: cardboardOfferSent ? 'Amman Recycling Co.' : 'No receiver yet',
              pickupTime: 'Flexible pickup',
              distance: 'Nearby recyclers',
              points: '45',
              urgency: 'Flexible',
              urgencyColor: AppColors.brightTeal,
              icon: Icons.inventory_2_rounded,
              progressStep: cardboardOfferSent ? 2 : 1,
              showMatchButton: !cardboardOfferSent,
              showCodeButton: false,
            ),
            const SizedBox(height: 16),
            _buildListingCard(
              title: 'Organic Vegetable Waste',
              category: 'Organic Waste',
              status: organicOfferSent ? 'Offer sent' : 'Match found',
              receiver: 'Amman Compost Hub',
              pickupTime: 'Tomorrow, 10:00 AM',
              distance: '4.1 km away',
              points: '60',
              urgency: 'Medium',
              urgencyColor: AppColors.freshGreen,
              icon: Icons.eco_rounded,
              progressStep: organicOfferSent ? 3 : 2,
              showMatchButton: !organicOfferSent,
              showCodeButton: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
        borderRadius: BorderRadius.circular(24),
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
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.list_alt_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recovery Listings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Track posted materials from AI classification to verified pickup.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.35,
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

  Widget _buildFilterChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = selectedFilter == index;

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() {
                selectedFilter = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryGreen : card,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: selected ? AppColors.primaryGreen : border,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                filters[index],
                style: TextStyle(
                  color: selected ? Colors.white : muted,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListingCard({
    required String title,
    required String category,
    required String status,
    required String receiver,
    required String pickupTime,
    required String distance,
    required String points,
    required String urgency,
    required Color urgencyColor,
    required IconData icon,
    required int progressStep,
    required bool showMatchButton,
    required bool showCodeButton,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(isDark ? 0.04 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  color: urgencyColor,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: text,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: TextStyle(
                        color: muted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: _statusColor(status),
                          size: 9,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            color: _statusColor(status),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: urgencyColor.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      urgency,
                      style: TextStyle(
                        color: urgencyColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.eco_rounded,
                        color: AppColors.primaryGreen,
                        size: 17,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        points,
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(height: 1, color: border),
          const SizedBox(height: 16),
          _buildReceiverInfo(
            receiver: receiver,
            pickupTime: pickupTime,
            distance: distance,
          ),
          const SizedBox(height: 18),
          _buildTimeline(progressStep),
          const SizedBox(height: 18),
          Row(
            children: [
              if (showMatchButton)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      HapticFeedback.lightImpact();

                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SmartMatchScreen(
                            materialTitle: title,
                            materialType: category,
                            receiverName: receiver == 'No receiver yet'
                                ? 'Amman Recycling Co.'
                                : receiver,
                            distance: distance,
                            pickupTime: pickupTime,
                            points: points,
                          ),
                        ),
                      );

                      if (!mounted) return;

                      if (result is Map && result['offerSent'] == true) {
                        setState(() {
                          if (title == 'Cardboard Boxes') {
                            cardboardOfferSent = true;
                          }

                          if (title == 'Organic Vegetable Waste') {
                            organicOfferSent = true;
                          }
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Offer sent to ${result['receiverName']}. Listing updated.'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.deepTeal,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                    label: const Text('Smart Match'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: BorderSide(
                        color: AppColors.primaryGreen.withOpacity(0.5),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              if (showMatchButton && showCodeButton) const SizedBox(width: 12),
              if (showCodeButton)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.mediumImpact();


                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PickupVerificationScreen(
                            materialTitle: title,
                            receiverName: receiver,
                            pickupTime: pickupTime,
                            points: points,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                    label: const Text('Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiverInfo({
    required String receiver,
    required String pickupTime,
    required String distance,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 21,
          backgroundColor: AppColors.brightTeal.withOpacity(0.14),
          child: Icon(
            receiver == 'No receiver yet'
                ? Icons.search_rounded
                : Icons.volunteer_activism_rounded,
            color: AppColors.deepTeal,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receiver,
                style: TextStyle(
                  color: text,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$pickupTime • $distance',
                style: TextStyle(
                  color: muted,
                  fontSize: 12.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(int progressStep) {
    final steps = [
      'Posted',
      'AI',
      'Match',
      'Pickup',
      'Verified',
    ];

    return Row(
      children: List.generate(steps.length, (index) {
        final completed = index <= progressStep;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 28,
                      width: 28,
                      decoration: BoxDecoration(
                        color: completed ? AppColors.primaryGreen : surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: completed ? AppColors.primaryGreen : border,
                        ),
                      ),
                      child: Icon(
                        completed ? Icons.check_rounded : Icons.circle,
                        color: completed ? Colors.white : border,
                        size: completed ? 17 : 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: completed ? AppColors.primaryGreen : muted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (index != steps.length - 1)
                Container(
                  height: 2,
                  width: 18,
                  color: index < progressStep ? AppColors.primaryGreen : border,
                ),
            ],
          ),
        );
      }),
    );
  }

  Color _statusColor(String status) {
    if (status.toLowerCase().contains('accepted')) {
      return AppColors.primaryGreen;
    }
    if (status.toLowerCase().contains('waiting')) {
      return Colors.orangeAccent;
    }
    if (status.toLowerCase().contains('match')) {
      return AppColors.brightTeal;
    }
    if (status.toLowerCase().contains('offer')) {
      return AppColors.freshGreen;
    }
    return AppColors.primaryGreen;
  }

  void _showSmartMatchSheet(
      String materialTitle,
      String receiver,
      String distance,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5,
                width: 48,
                decoration: BoxDecoration(
                  color: border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 22),
              CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primaryGreen,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Best Match Recommendation',
                style: TextStyle(
                  color: text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                receiver == 'No receiver yet'
                    ? 'AI is still searching for the best recovery partner.'
                    : '$receiver is recommended for $materialTitle.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: muted,
                  fontSize: 13.5,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              _matchReason('Accepts this material category'),
              _matchReason('Available within selected pickup time'),
              _matchReason('Nearby partner: $distance'),
              _matchReason('High reliability score: 94%'),
              const SizedBox(height: 18),
            ],
          ),
        );
      },
    );
  }

  Widget _matchReason(String textValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.freshGreen,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              textValue,
              style: TextStyle(
                color: text,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}