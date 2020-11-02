import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/data/repository/local_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/remote_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/response_model.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import 'bloc.dart';

class EpisodesListBloc extends Bloc<EpisodesListEvent, EpisodesListState> {
  NavigationScreenBloc navigationBloc;

  EpisodesListBloc(navigationBloc) : super(InitialEpisodesListState()) {
    this.navigationBloc = navigationBloc;
  }

  @override
  Stream<EpisodesListState> mapEventToState(
    EpisodesListEvent event,
  ) async* {
    final currentState = state;
    if (event is ReachedBottomOfEpisodesList && !_hasReachedMax(currentState)) {
      try {
        if (currentState is InitialEpisodesListState) {
          final data = await _fetchEpisodes(1);
          yield EpisodesListLoaded(
              episodes: data.data,
              hasReachedMax: !data.hasMore,
              nextPage: data.nextPageNumber);
          return;
        }
        if (currentState is EpisodesListLoaded) {
          if (currentState.hasReachedMax) {
            yield currentState;
          }
          final data = await _fetchEpisodes(currentState.nextPage);
          yield EpisodesListLoaded(
              episodes: currentState.episodes + data.data,
              hasReachedMax: !data.hasMore,
              nextPage: data.nextPageNumber);
        }
      } catch (e, s) {
        print("$e,$s");
        yield EpisodesListError();
      }
    }
  }

  bool _hasReachedMax(EpisodesListState state) =>
      state is EpisodesListLoaded && state.hasReachedMax;

  Future<Response> _fetchEpisodes(int page) async {
    var data;
    if (navigationBloc.hasInternetConnection) {
      var response = await RemoteDataRepository.getAllEpisodesForPage(page);
      response.fold((l) => throw (ServerException), (r) => data = r);
    } else {
      var response = await LocalDataRepository.getAllEpisodesForPage(page);
      response.fold((l) => throw (CacheException), (r) => data = r);
    }
    return data;
  }
}
