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

class DemoAppState {
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
        progressStep: 3,
        showCodeButton: false,
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

  static void resetDemo() {
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