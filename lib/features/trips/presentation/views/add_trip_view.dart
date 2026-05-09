import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_event.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_state.dart';
import '../widgets/add_trip_bottom_action_bar.dart';
import 'package:waseet_project/features/trips/presentation/widgets/add_trip_form_widgets.dart';

class AddTripView extends StatefulWidget {
  const AddTripView({super.key});

  @override
  State<AddTripView> createState() => _AddTripViewState();
}

class _AddTripViewState extends State<AddTripView> {
  final _formKey = GlobalKey<FormState>();
  final _fromCityController = TextEditingController();
  final _toCityController = TextEditingController();
  final _notesController = TextEditingController();
  final _priceController = TextEditingController();

  int _seats = 3;
  bool _allowParcel = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _fromCityController.dispose();
    _toCityController.dispose();
    _notesController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<TripsBloc, TripsState>(
      listener: (context, state) {
        if (state is TripAddedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة الرحلة بنجاح')),
          );
          context.read<TripsBloc>().add(const LoadTrips());
          Navigator.pop(context);
        } else if (state is TripsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: _buildAppBar(colorScheme),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            children: [
              RouteSectionWidget(
                fromController: _fromCityController,
                toController: _toCityController,
              ),
              const SizedBox(height: 24),
              _buildTimingAndSeatsRow(),
              const SizedBox(height: 24),
              OptionsSectionWidget(
                allowParcel: _allowParcel,
                onAllowParcelChanged: (val) =>
                    setState(() => _allowParcel = val),
                notesController: _notesController,
                priceController: _priceController,
              ),
            ],
          ),
        ),
        bottomNavigationBar: AddTripBottomActionBar(
          formKey: _formKey,
          fromCityController: _fromCityController,
          toCityController: _toCityController,
          notesController: _notesController,
          priceController: _priceController,
          seats: _seats,
          allowParcel: _allowParcel,
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
        ),
      ),
    );
  }

  AppBar _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.9),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_forward, color: colorScheme.primary),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'إضافة رحلة',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      centerTitle: false,
    );
  }

  Widget _buildTimingAndSeatsRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TimingSectionWidget(
            selectedDate: _selectedDate,
            selectedTime: _selectedTime,
            onDateChanged: (val) => setState(() => _selectedDate = val),
            onTimeChanged: (val) => setState(() => _selectedTime = val),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SeatsSectionWidget(
            seats: _seats,
            onSeatsChanged: (val) => setState(() => _seats = val),
          ),
        ),
      ],
    );
  }
}
