import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/bookings/domain/entities/booking_entity.dart';
import 'package:waseet_project/features/bookings/presentation/bloc/booking_bloc.dart';
import 'package:waseet_project/features/bookings/presentation/bloc/booking_bloc_state.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

class BookingView extends StatefulWidget {
  final TripEntity trip;

  const BookingView({super.key, required this.trip});

  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  late int _selectedSeats;

  @override
  void initState() {
    super.initState();
    _selectedSeats = widget.trip.availableSeats > 0 ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalPrice = _selectedSeats * widget.trip.price;

    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم الحجز بنجاح!')),
          );
          Navigator.pop(context); // Go back to details
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('تأكيد الحجز', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTripSummary(colorScheme),
              const SizedBox(height: 32),
              const Text(
                'عدد الركاب',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 16),
              _buildSeatSelector(colorScheme),
              const SizedBox(height: 32),
              const Text(
                'بيانات الحاجز',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
              ),
              const SizedBox(height: 16),
              _buildBookerInfo(colorScheme),
              const SizedBox(height: 40),
              _buildPriceSummary(totalPrice, colorScheme),
            ],
          ),
        ),
        bottomNavigationBar: _buildConfirmButton(totalPrice, colorScheme),
      ),
    );
  }

  Widget _buildTripSummary(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.05), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocationItem(widget.trip.fromCity, 'من'),
              const Icon(Icons.trending_flat, color: Colors.grey),
              _buildLocationItem(widget.trip.toCity, 'إلى'),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              Text(widget.trip.driverName, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${widget.trip.price.toStringAsFixed(0)} ل.س / مقعد', 
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String city, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(city, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildSeatSelector(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCounterBtn(Icons.remove, () {
          if (_selectedSeats > 1) setState(() => _selectedSeats--);
        }, colorScheme),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '$_selectedSeats',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
        ),
        _buildCounterBtn(Icons.add, () {
          if (_selectedSeats < widget.trip.availableSeats) setState(() => _selectedSeats++);
        }, colorScheme),
      ],
    );
  }

  Widget _buildCounterBtn(IconData icon, VoidCallback onTap, ColorScheme colorScheme) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: colorScheme.primary),
      ),
    );
  }

  Widget _buildBookerInfo(ColorScheme colorScheme) {
    final user = context.read<AuthBloc>().state.user;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.05), blurRadius: 12)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(Icons.person, color: colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName ?? '—',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      user?.phone ?? '—',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'أنت',
                  style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(double total, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('الإجمالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
          Text(
            '${total.toStringAsFixed(0)} ل.س',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(double total, ColorScheme colorScheme) {
    final bool isFull = widget.trip.availableSeats <= 0;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ElevatedButton(
            onPressed: isFull ? null : () => _confirmBooking(total),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              backgroundColor: isFull ? Colors.grey : colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              isFull ? 'الرحلة ممتلئة' : 'تأكيد الحجز الآن', 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo', color: Colors.white)
            ),
          );
        },
      ),
    );
  }

  void _confirmBooking(double total) {
    final user = context.read<AuthBloc>().state.user;
    if (user == null) return;

    final booking = BookingEntity(
      id: '',
      tripId: widget.trip.id,
      passengerId: user.uId,
      passengerName: user.fullName,
      passengerPhone: user.phone,
      driverId: widget.trip.userId,
      driverName: widget.trip.driverName,
      seatsCount: _selectedSeats,
      totalPrice: total,
      status: 'pending',
      createdAt: DateTime.now(),
      fromCity: widget.trip.fromCity,
      toCity: widget.trip.toCity,
      tripDate: widget.trip.date,
    );

    context.read<BookingBloc>().add(BookTripRequested(booking));
  }
}
