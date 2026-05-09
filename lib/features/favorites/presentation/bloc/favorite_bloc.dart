import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:waseet_project/features/favorites/data/repositories/favorite_repository_impl.dart';
import 'package:waseet_project/features/trips/domain/entities/trip_entity.dart';

// Events
abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {
  final String userId;
  LoadFavorites(this.userId);
  @override
  List<Object?> get props => [userId];
}

class ToggleFavorite extends FavoriteEvent {
  final String userId;
  final TripEntity trip;
  ToggleFavorite({required this.userId, required this.trip});
  @override
  List<Object?> get props => [userId, trip];
}

// States
abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}
class FavoriteLoading extends FavoriteState {}
class FavoritesLoaded extends FavoriteState {
  final List<TripEntity> favorites;
  FavoritesLoaded(this.favorites);
  @override
  List<Object?> get props => [favorites];
}
class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc({required this.repository}) : super(FavoriteInitial()) {
    on<LoadFavorites>((event, emit) async {
      emit(FavoriteLoading());
      final result = await repository.getFavorites(event.userId);
      result.fold(
        (failure) => emit(FavoriteError(failure.message)),
        (favorites) => emit(FavoritesLoaded(favorites)),
      );
    });

    on<ToggleFavorite>((event, emit) async {
      final currentFavorites = state is FavoritesLoaded ? (state as FavoritesLoaded).favorites : <TripEntity>[];
      final isFavorite = currentFavorites.any((t) => t.id == event.trip.id);

      if (isFavorite) {
        await repository.removeFromFavorites(event.userId, event.trip.id);
      } else {
        await repository.addToFavorites(event.userId, event.trip);
      }

      // Reload favorites after toggle
      add(LoadFavorites(event.userId));
    });
  }
}
