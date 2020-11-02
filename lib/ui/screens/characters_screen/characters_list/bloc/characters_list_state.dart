import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';

abstract class CharactersListState extends Equatable {
  final Map<String, String> filters;

  @override
  List<Object> get props => [];

  const CharactersListState(this.filters);
}

class InitialCharactersListState extends CharactersListState {
  InitialCharactersListState(Map<String, String> filters) : super(filters);
}

class LoadingCharacters extends CharactersListState {
  LoadingCharacters(Map<String, String> filters) : super(filters);
}

class CharactersLoaded extends CharactersListState {
  final List<Character> characters;
  final bool hasReachedMax;
  final int nextPage;

  CharactersLoaded(Map<String, String> filters,
      {this.hasReachedMax, this.characters, this.nextPage})
      : super(filters);

  CharactersLoaded copyWith(
      {List<Character> characters, bool hasReachedMax, int nextPage}) {
    return CharactersLoaded(this.filters,
        characters: characters ?? this.characters,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        nextPage: nextPage ?? this.nextPage);
  }

  @override
  List<Object> get props => [characters, hasReachedMax];
}

class CharactersListError extends CharactersListState {
  CharactersListError(Map<String, String> filters) : super(filters);
}
