import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

class TripDetailsAppBar extends StatelessWidget {
  final TripEntity trip;
  const TripDetailsAppBar({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = context.read<AuthBloc>().state.user;

    return SliverAppBar(
      pinned: true,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'تفاصيل الرحلة',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.primary),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        if (user != null)
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              bool isFavorite = false;
              if (state is FavoritesLoaded) {
                isFavorite = state.favorites.any((t) => t.id == trip.id);
              }
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : colorScheme.primary,
                ),
                onPressed: () {
                  context.read<FavoriteBloc>().add(
                        ToggleFavorite(userId: user.uId, trip: trip),
                      );
                },
              );
            },
          ),
        IconButton(
          icon: Icon(Icons.share, color: colorScheme.primary),
          onPressed: () {},
        ),
      ],
    );
  }
}
