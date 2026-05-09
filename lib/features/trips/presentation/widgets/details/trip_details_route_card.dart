import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

class TripDetailsRouteCard extends StatelessWidget {
  final TripEntity trip;

  const TripDetailsRouteCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String formattedDate = DateFormat('EEEE، d MMMM').format(trip.date);
    final String formattedTime = DateFormat('hh:mm a').format(trip.date);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCityInfo(context, label: 'نقطة الانطلاق', city: trip.fromCity),
              _buildRouteDivider(colorScheme),
              _buildCityInfo(
                context,
                label: 'الوجهة',
                city: trip.toCity,
                crossAxisAlignment: CrossAxisAlignment.end,
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildInfoItem(
                colorScheme,
                icon: Icons.calendar_today,
                label: 'التاريخ',
                value: formattedDate,
              ),
              const Spacer(),
              _buildInfoItem(
                colorScheme,
                icon: Icons.schedule,
                label: 'وقت التحرك',
                value: formattedTime,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCityInfo(
    BuildContext context, {
    required String label,
    required String city,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          city,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildRouteDivider(ColorScheme colorScheme) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Divider(color: Colors.grey.shade300, thickness: 2),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_car,
              color: colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    ColorScheme colorScheme, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
