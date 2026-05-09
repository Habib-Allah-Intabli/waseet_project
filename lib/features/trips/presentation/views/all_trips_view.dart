import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_event.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_state.dart';
import 'package:waseet_project/features/home/presentation/widgets/trip_card.dart';

class AllTripsView extends StatelessWidget {
  const AllTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('all_trips'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) {
          if (state is TripsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TripsLoaded) {
            if (state.trips.isEmpty) {
              return Center(child: Text('no_trips'.tr()));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TripsBloc>().add(const LoadTrips());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.trips.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TripCard(trip: state.trips[index]),
                  );
                },
              ),
            );
          } else if (state is TripsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
