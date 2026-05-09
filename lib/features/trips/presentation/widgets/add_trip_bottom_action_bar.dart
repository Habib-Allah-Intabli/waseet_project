import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_event.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_state.dart';

class AddTripBottomActionBar extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fromCityController;
  final TextEditingController toCityController;
  final TextEditingController notesController;
  final TextEditingController priceController;
  final int seats;
  final bool allowParcel;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;

  const AddTripBottomActionBar({
    super.key,
    required this.formKey,
    required this.fromCityController,
    required this.toCityController,
    required this.notesController,
    required this.priceController,
    required this.seats,
    required this.allowParcel,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) {
          if (state is TripsLoading) {
            return const SizedBox(
              height: 56,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return ElevatedButton(
            onPressed: () => _onPublishPressed(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0, // Elevation is handled by the container/border if needed
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'نشر الرحلة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onPublishPressed(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final user = context.read<AuthBloc>().state.user;
      final userId = user?.uId ?? '';
      final userName = user?.fullName ?? 'غير معروف';

      final DateTime tripDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final trip = TripEntity(
        id: '',
        userId: userId,
        fromCity: fromCityController.text,
        toCity: toCityController.text,
        date: tripDateTime,
        availableSeats: seats,
        allowParcel: allowParcel,
        notes: notesController.text,
        status: 'active',
        createdAt: DateTime.now(),
        price: double.tryParse(priceController.text) ?? 0.0,
        driverName: userName,
      );
      context.read<TripsBloc>().add(AddTrip(trip));
    }
  }
}
