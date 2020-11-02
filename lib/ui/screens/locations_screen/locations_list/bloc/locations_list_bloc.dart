import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/data/repository/local_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/remote_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/response_model.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import 'bloc.dart';

class LocationsListBloc extends Bloc<LocationsListEvent, LocationsListState> {
  NavigationScreenBloc _navigationScreenBloc;

  LocationsListBloc(_navigationScreenBloc)
      : super(InitialLocationsListState()) {
    this._navigationScreenBloc = _navigationScreenBloc;
  }

  @override
  Stream<LocationsListState> mapEventToState(
    LocationsListEvent event,
  ) async* {
    final currentState = state;
    if (event is ReachedBottomOfLocationsList &&
        !_hasReachedMax(currentState)) {
      try {
        if (currentState is InitialLocationsListState) {
          final data = await _fetchLocations(1);
          yield LocationsListLoaded(
              locations: data.data,
              hasReachedMax: !data.hasMore,
              nextPage: data.nextPageNumber);
          return;
        }
        if (currentState is LocationsListLoaded) {
          if (currentState.hasReachedMax) {
            yield currentState;
          }
          final data = await _fetchLocations(currentState.nextPage);
          yield LocationsListLoaded(
              locations: currentState.locations + data.data,
              hasReachedMax: !data.hasMore,
              nextPage: data.nextPageNumber);
        }
      } catch (e, s) {
        print("$e,$s");
        yield LocationsListError();
      }
    }
  }

  bool _hasReachedMax(LocationsListState state) =>
      state is LocationsListLoaded && state.hasReachedMax;

  Future<Response> _fetchLocations(int page) async {
    var data;
    if (_navigationScreenBloc.hasInternetConnection) {
      var response = await RemoteDataRepository.getAllLocationsForPage(page);
      response.fold((l) => throw (ServerException), (r) => data = r);
    } else {
      var response = await LocalDataRepository.getAllLocationsForPage(page);
      response.fold((l) => throw (CacheException), (r) => data = r);
    }
    return data;
  }
}
