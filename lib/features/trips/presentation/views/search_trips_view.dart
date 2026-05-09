import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_event.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_state.dart';
import 'package:waseet_project/features/trips/presentation/widgets/search_bar_widget.dart';
import 'package:waseet_project/features/home/presentation/widgets/trip_card.dart';

class SearchTripsView extends StatefulWidget {
  const SearchTripsView({super.key});

  @override
  State<SearchTripsView> createState() => _SearchTripsViewState();
}

class _SearchTripsViewState extends State<SearchTripsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search_trips'.tr()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              controller: _searchController,
              hintText: 'search_hint'.tr(),
              onSearch: _performSearch,
              onClear: _clearSearch,
            ),
          ),
          Expanded(
            child: BlocBuilder<TripsBloc, TripsState>(
              builder: (context, state) {
                if (state is TripsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TripsLoaded) {
                  final filteredTrips = _searchQuery.isEmpty
                      ? state.trips
                      : state.trips.where((trip) {
                          final query = _searchQuery.toLowerCase();
                          return trip.fromCity.toLowerCase().contains(query) ||
                              trip.toCity.toLowerCase().contains(query) ||
                              trip.driverName.toLowerCase().contains(query) ||
                              trip.notes.toLowerCase().contains(query);
                        }).toList();

                  if (filteredTrips.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'no_results'.tr(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TripsBloc>().add(const LoadTrips());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredTrips.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TripCard(trip: filteredTrips[index]),
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
          ),
        ],
      ),
    );
  }
}
