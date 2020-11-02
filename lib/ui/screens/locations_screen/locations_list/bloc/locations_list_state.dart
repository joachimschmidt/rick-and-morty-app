import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/data/models/location/location.dart';

abstract class LocationsListState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialLocationsListState extends LocationsListState {}

class LoadingLocations extends LocationsListState {}

class LocationsListLoaded extends LocationsListState {
  final List<Location> locations;
  final bool hasReachedMax;
  final int nextPage;

  LocationsListLoaded({this.hasReachedMax, this.locations, this.nextPage});

  LocationsListLoaded copyWith(
      {List<Location> locations, bool hasReachedMax, int nextPage}) {
    return LocationsListLoaded(
        locations: locations ?? this.locations,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        nextPage: nextPage ?? this.nextPage);
  }

  @override
  List<Object> get props => [locations, hasReachedMax];
}

class LocationsListError extends LocationsListState {}
