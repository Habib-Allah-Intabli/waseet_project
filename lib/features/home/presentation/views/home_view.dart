import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_state.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_event.dart';
import 'package:waseet_project/features/trips/presentation/bloc/trips_state.dart';
import 'package:waseet_project/features/home/presentation/widgets/home_header_widgets.dart';
import 'package:waseet_project/features/home/presentation/widgets/trip_card.dart';
import 'package:waseet_project/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:waseet_project/features/home/presentation/views/profile_view.dart';
import 'package:waseet_project/features/trips/presentation/views/all_trips_view.dart';

import 'package:waseet_project/features/bookings/presentation/views/my_trips_view.dart';
import 'package:waseet_project/features/home/presentation/widgets/home_drawer.dart';
import 'package:waseet_project/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:waseet_project/core/services/notification_service.dart';
import 'package:waseet_project/core/config/di.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthBloc>().state.user;
    context.read<TripsBloc>().add(const LoadTrips());
    if (user != null) {
      context.read<FavoriteBloc>().add(LoadFavorites(user.uId));
      getIt<NotificationService>().startListeningForNotifications(user.uId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: colorScheme.surface,
        drawer: const HomeDrawer(),
        body: _currentIndex == 0
            ? CustomScrollView(
                slivers: [
                  const HomeSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(height: 24),
                          HeroSection(),
                          SizedBox(height: 32),
                          SmartMatchBanner(),
                          SizedBox(height: 24),
                          // FilterTabs(),
                          // SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  _buildTripsList(),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ), // padding for FAB
                ],
              )
            : _currentIndex == 1
            ? const MyTripsView()
            : _currentIndex == 2
            ? const AllTripsView()
            : const ProfileView(),
        floatingActionButton: _currentIndex == 0
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  onPressed: () => Navigator.pushNamed(context, '/add-trip'),
                  backgroundColor: colorScheme.primary,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'إضافة رحلة',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTripsList() {
    return BlocBuilder<TripsBloc, TripsState>(
      builder: (context, state) {
        if (state is TripsLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is TripsLoaded) {
          if (state.trips.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'لا توجد رحلات متوفرة حالياً',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }
          // Limit to 4 trips for Home page
          final tripsToShow = state.trips.length > 4
              ? state.trips.sublist(0, 4)
              : state.trips;

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final trip = tripsToShow[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TripCard(trip: trip),
                );
              }, childCount: tripsToShow.length),
            ),
          );
        } else if (state is TripsError) {
          return SliverToBoxAdapter(child: Center(child: Text(state.message)));
        }
        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}
