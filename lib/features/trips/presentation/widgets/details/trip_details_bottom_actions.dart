import 'package:flutter/material.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/bookings/presentation/views/booking_view.dart';

class TripDetailsBottomActions extends StatelessWidget {
  final TripEntity trip;
  const TripDetailsBottomActions({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: _buildPrimaryButton(context, 'احجز مقعد')),
          const SizedBox(width: 12),
          Expanded(child: _buildSecondaryButton('ابدأ محادثة')),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context, String text) {
    final bool isFull = trip.availableSeats <= 0;
    
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFull 
            ? [Colors.grey, Colors.grey.shade400] 
            : [const Color(0xFF000666), const Color(0xFF1A237E)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isFull ? Colors.grey : const Color(0xFF000666)).withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isFull ? null : () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BookingView(trip: trip)),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              isFull ? 'الرحلة ممتلئة' : text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
        side: const BorderSide(color: Color(0xFF000666), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF000666),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
