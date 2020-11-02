import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rick_and_morty_app/core/error/exceptions.dart';
import 'package:rick_and_morty_app/data/repository/local_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/remote_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/response_model.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import 'bloc.dart';

class CharactersListBloc
    extends Bloc<CharactersListEvent, CharactersListState> {
  NavigationScreenBloc navigationBloc;

  CharactersListBloc(filters, navigationBloc)
      : super(InitialCharactersListState(filters)) {
    this.navigationBloc = navigationBloc;
  }

  @override
  Stream<CharactersListState> mapEventToState(
    CharactersListEvent event,
  ) async* {
    final currentState = state;
    if (event is ReachedBottomOfCharactersList &&
        !_hasReachedMax(currentState)) {
      try {
        if (currentState is InitialCharactersListState) {
          final data = await _fetchCharacters(1);
          yield CharactersLoaded(state.filters,
              characters: data.data,
              hasReachedMax: !data.hasMore,
              nextPage: data.nextPageNumber);
          return;
        }
        if (currentState is CharactersLoaded) {
          if (currentState.hasReachedMax) {
            yield currentState;
          }
          final data = await _fetchCharacters(currentState.nextPage);
          yield CharactersLoaded(state.filters,
              characters: currentState.characters + data.data,
              hasReachedMax: !data.hasMore,
              nextPage: data.nextPageNumber);
        }
      } catch (e, s) {
        print("$e,$s");
        yield CharactersListError(
          state.filters,
        );
      }
    } else if (event is FiltersChanged) {
      yield InitialCharactersListState(event.newFilters);
      add(ReachedBottomOfCharactersList());
    }
  }

  bool _hasReachedMax(CharactersListState state) =>
      state is CharactersLoaded && state.hasReachedMax;

  Future<Response> _fetchCharacters(int page) async {
    var data;
    if (navigationBloc.hasInternetConnection) {
      var response = await RemoteDataRepository.getAllCharactersForPage(
          page, state.filters);
      response.fold((l) => throw (ServerException), (r) => data = r);
    } else {
      var response = await LocalDataRepository.getAllCharactersForPage(page);
      response.fold((l) => throw (CacheException), (r) => data = r);
    }
    return data;
  }
}
