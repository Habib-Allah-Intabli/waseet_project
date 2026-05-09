import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waseet_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:waseet_project/features/favorites/presentation/bloc/favorite_bloc.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

class TripCardHeader extends StatelessWidget {
  final TripEntity trip;
  final String price;
  final String rating;
  final String imageUrl;

  const TripCardHeader({
    super.key,
    required this.trip,
    this.price = '25,000',
    this.rating = '4.9',
    this.imageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuC2GkycbITsOZUQWkcSPz124uf0ZeJODsEuMY7ehd3OFhpWdOi_3HFP5fXHDFrGP3IBy2tTfMrd2UKVs-GjF_kSbkCgg1rjhZbJ25FjIhqyw0-ILo4Yf6R78CJ-4Jp5ReJReL3ECej-meJ8LLJwvOrNC7BUsdiDCNMllsg9wUKMdf9ajFXm8kpYYcyyS1VQkgfD1WCeAQ5FTz04kEBY9P2LZT-Do5pZmaQuxdn3gvvJFJL6RNqjR00Mw4nhD8adlIONDXXk2gCDRUI',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = context.read<AuthBloc>().state.user;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.driverName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.verified,
                      color: colorScheme.secondary,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'حساب موثق',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
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
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<FavoriteBloc>().add(
                            ToggleFavorite(userId: user.uId, trip: trip),
                          );
                    },
                  );
                },
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  trip.price.toStringAsFixed(0),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  'ل.س / مقعد',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
