import 'package:flutter/material.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/trips/presentation/views/trip_details_view.dart';
import 'trip_card_header.dart';
import 'trip_card_route_details.dart';
import 'trip_card_actions.dart';

class TripCard extends StatelessWidget {
  final TripEntity trip;

  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TripDetailsView(trip: trip)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            TripCardHeader(
              trip: trip,
            ),
            const SizedBox(height: 24),
            TripCardRouteDetails(trip: trip),
            const SizedBox(height: 24),
            TripCardActions(
              allowParcel: trip.allowParcel,
              onBookPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDetailsView(trip: trip),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
