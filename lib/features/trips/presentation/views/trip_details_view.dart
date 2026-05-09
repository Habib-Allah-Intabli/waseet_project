import 'package:flutter/material.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import '../widgets/details/trip_details_app_bar.dart';
import '../widgets/details/trip_details_route_card.dart';
import '../widgets/details/trip_details_driver_profile.dart';
import '../widgets/details/trip_details_highlights.dart';
import '../widgets/details/trip_details_notes.dart';
import '../widgets/details/trip_details_reviews.dart';
import '../widgets/details/trip_details_bottom_actions.dart';

class TripDetailsView extends StatelessWidget {
  final TripEntity trip;

  const TripDetailsView({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              TripDetailsAppBar(trip: trip),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TripDetailsRouteCard(trip: trip),
                      const SizedBox(height: 24),
                      TripDetailsDriverProfile(driverName: trip.driverName),
                      const SizedBox(height: 24),
                      TripDetailsHighlights(
                        availableSeats: trip.availableSeats,
                        allowParcel: trip.allowParcel,
                      ),
                      const SizedBox(height: 24),
                      TripDetailsNotes(notes: trip.notes),
                      const SizedBox(height: 24),
                      const TripDetailsReviews(),
                      const SizedBox(height: 120), // Bottom padding for actions
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TripDetailsBottomActions(trip: trip),
          ),
        ],
      ),
    );
  }
}
