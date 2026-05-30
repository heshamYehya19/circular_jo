import 'package:flutter/material.dart';

class DemoListing {
  final String id;
  final String title;
  final String category;
  final String status;
  final String receiver;
  final String pickupTime;
  final String distance;
  final String points;
  final String urgency;
  final IconData icon;
  final int progressStep;
  final bool showMatchButton;
  final bool showCodeButton;

  DemoListing({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.receiver,
    required this.pickupTime,
    required this.distance,
    required this.points,
    required this.urgency,
    required this.icon,
    required this.progressStep,
    required this.showMatchButton,
    required this.showCodeButton,
  });

  DemoListing copyWith({
    String? status,
    String? receiver,
    String? pickupTime,
    String? distance,
    String? points,
    String? urgency,
    int? progressStep,
    bool? showMatchButton,
    bool? showCodeButton,
  }) {
    return DemoListing(
      id: id,
      title: title,
      category: category,
      status: status ?? this.status,
      receiver: receiver ?? this.receiver,
      pickupTime: pickupTime ?? this.pickupTime,
      distance: distance ?? this.distance,
      points: points ?? this.points,
      urgency: urgency ?? this.urgency,
      icon: icon,
      progressStep: progressStep ?? this.progressStep,
      showMatchButton: showMatchButton ?? this.showMatchButton,
      showCodeButton: showCodeButton ?? this.showCodeButton,
    );
  }
}
class DemoImpactStats {
  final int wasteKg;
  final int points;
  final int verifiedPickups;
  final int mealsSupported;
  final int co2Avoided;

  const DemoImpactStats({
    required this.wasteKg,
    required this.points,
    required this.verifiedPickups,
    required this.mealsSupported,
    required this.co2Avoided,
  });

  DemoImpactStats copyWith({
    int? wasteKg,
    int? points,
    int? verifiedPickups,
    int? mealsSupported,
    int? co2Avoided,
  }) {
    return DemoImpactStats(
      wasteKg: wasteKg ?? this.wasteKg,
      points: points ?? this.points,
      verifiedPickups: verifiedPickups ?? this.verifiedPickups,
      mealsSupported: mealsSupported ?? this.mealsSupported,
      co2Avoided: co2Avoided ?? this.co2Avoided,
    );
  }
}
class DemoAppState {
  static final ValueNotifier<DemoImpactStats> impactStats =
  ValueNotifier<DemoImpactStats>(
    const DemoImpactStats(
      wasteKg: 1240,
      points: 8650,
      verifiedPickups: 74,
      mealsSupported: 2480,
      co2Avoided: 620,
    ),
  );
  static final ValueNotifier<List<DemoListing>> listings =
  ValueNotifier<List<DemoListing>>([
    DemoListing(
      id: 'food-demo',
      title: '10 kg Surplus Food',
      category: 'Surplus Food',
      status: 'Pickup accepted',
      receiver: 'Hope Charity',
      pickupTime: 'Today, 6:00 PM',
      distance: '2.4 km away',
      points: '80',
      urgency: 'High urgency',
      icon: Icons.restaurant_rounded,
      progressStep: 3,
      showMatchButton: true,
      showCodeButton: true,
    ),
    DemoListing(
      id: 'cardboard-demo',
      title: 'Cardboard Boxes',
      category: 'Recyclable Material',
      status: 'Waiting for receiver',
      receiver: 'No receiver yet',
      pickupTime: 'Flexible pickup',
      distance: 'Nearby recyclers',
      points: '45',
      urgency: 'Flexible',
      icon: Icons.inventory_2_rounded,
      progressStep: 1,
      showMatchButton: true,
      showCodeButton: false,
    ),
    DemoListing(
      id: 'organic-demo',
      title: 'Organic Vegetable Waste',
      category: 'Organic Waste',
      status: 'Match found',
      receiver: 'Amman Compost Hub',
      pickupTime: 'Tomorrow, 10:00 AM',
      distance: '4.1 km away',
      points: '60',
      urgency: 'Medium',
      icon: Icons.eco_rounded,
      progressStep: 2,
      showMatchButton: true,
      showCodeButton: false,
    ),
  ]);

  static void addListing({
    required String title,
    required String category,
    required String pickupTime,
    required String points,
    required String urgency,
    required IconData icon,
  }) {
    final newListing = DemoListing(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      status: 'Waiting for receiver',
      receiver: 'No receiver yet',
      pickupTime: pickupTime,
      distance: 'Searching nearby partners',
      points: points,
      urgency: urgency,
      icon: icon,
      progressStep: 1,
      showMatchButton: true,
      showCodeButton: false,
    );

    listings.value = [
      newListing,
      ...listings.value,
    ];
  }

  static void markOfferSent(String id, String receiverName) {
    listings.value = listings.value.map((listing) {
      if (listing.id != id) return listing;

      return listing.copyWith(
        status: 'Offer sent',
        receiver: receiverName,
        distance: '2.4 km away',
        progressStep: 2,
        showCodeButton: true,
      );
    }).toList();
  }

  static void markPickupVerified(String id) {
    listings.value = listings.value.map((listing) {
      if (listing.id != id) return listing;

      return listing.copyWith(
        status: 'Verified completed',
        progressStep: 4,
        showMatchButton: false,
        showCodeButton: false,
      );
    }).toList();
  }
  static void addVerifiedImpact({
    required String materialTitle,
    required String points,
  }) {
    final current = impactStats.value;

    final extractedPoints = int.tryParse(
      RegExp(r'\d+').firstMatch(points)?.group(0) ?? '0',
    ) ??
        0;

    final extractedKg = int.tryParse(
      RegExp(r'\d+').firstMatch(materialTitle)?.group(0) ?? '10',
    ) ??
        10;

    final estimatedMeals = materialTitle.toLowerCase().contains('food')
        ? extractedKg * 2
        : 0;

    final estimatedCo2 = (extractedKg * 0.5).round();

    impactStats.value = current.copyWith(
      wasteKg: current.wasteKg + extractedKg,
      points: current.points + extractedPoints,
      verifiedPickups: current.verifiedPickups + 1,
      mealsSupported: current.mealsSupported + estimatedMeals,
      co2Avoided: current.co2Avoided + estimatedCo2,
    );
  }

  static void resetDemo() {
    impactStats.value = const DemoImpactStats(
      wasteKg: 1240,
      points: 8650,
      verifiedPickups: 74,
      mealsSupported: 2480,
      co2Avoided: 620,
    );
    listings.value = [
      DemoListing(
        id: 'food-demo',
        title: '10 kg Surplus Food',
        category: 'Surplus Food',
        status: 'Pickup accepted',
        receiver: 'Hope Charity',
        pickupTime: 'Today, 6:00 PM',
        distance: '2.4 km away',
        points: '80',
        urgency: 'High urgency',
        icon: Icons.restaurant_rounded,
        progressStep: 3,
        showMatchButton: true,
        showCodeButton: true,
      ),
      DemoListing(
        id: 'cardboard-demo',
        title: 'Cardboard Boxes',
        category: 'Recyclable Material',
        status: 'Waiting for receiver',
        receiver: 'No receiver yet',
        pickupTime: 'Flexible pickup',
        distance: 'Nearby recyclers',
        points: '45',
        urgency: 'Flexible',
        icon: Icons.inventory_2_rounded,
        progressStep: 1,
        showMatchButton: true,
        showCodeButton: false,
      ),
      DemoListing(
        id: 'organic-demo',
        title: 'Organic Vegetable Waste',
        category: 'Organic Waste',
        status: 'Match found',
        receiver: 'Amman Compost Hub',
        pickupTime: 'Tomorrow, 10:00 AM',
        distance: '4.1 km away',
        points: '60',
        urgency: 'Medium',
        icon: Icons.eco_rounded,
        progressStep: 2,
        showMatchButton: true,
        showCodeButton: false,
      ),
    ];
  }
}