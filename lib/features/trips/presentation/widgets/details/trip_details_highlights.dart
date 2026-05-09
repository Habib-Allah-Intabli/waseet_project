import 'package:flutter/material.dart';

class TripDetailsHighlights extends StatelessWidget {
  final int availableSeats;
  final bool allowParcel;

  const TripDetailsHighlights({
    super.key,
    required this.availableSeats,
    required this.allowParcel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _buildHighlightItem(
          colorScheme: colorScheme,
          icon: Icons.airline_seat_recline_normal,
          text: '$availableSeats مقاعد متاحة',
        ),
        const SizedBox(width: 16),
        _buildHighlightItem(
          colorScheme: colorScheme,
          icon: Icons.inventory_2,
          text: 'طرود: ${allowParcel ? "نعم" : "لا"}',
        ),
      ],
    );
  }

  Widget _buildHighlightItem({
    required ColorScheme colorScheme,
    required IconData icon,
    required String text,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
