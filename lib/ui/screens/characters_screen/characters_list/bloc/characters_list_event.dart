abstract class CharactersListEvent {}

class LoadedCharacters extends CharactersListEvent {}

class ReachedBottomOfCharactersList extends CharactersListEvent {}

class FiltersChanged extends CharactersListEvent {
  Map<String, String> newFilters;

  FiltersChanged(this.newFilters);
}

class LoadingMoreCharacters extends CharactersListEvent {}
