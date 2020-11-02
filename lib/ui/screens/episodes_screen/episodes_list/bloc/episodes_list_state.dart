import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/data/models/episode/episode.dart';

abstract class EpisodesListState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialEpisodesListState extends EpisodesListState {}

class LoadingEpisodes extends EpisodesListState {}

class EpisodesListLoaded extends EpisodesListState {
  final List<Episode> episodes;
  final bool hasReachedMax;
  final int nextPage;

  EpisodesListLoaded({this.hasReachedMax, this.episodes, this.nextPage});

  EpisodesListLoaded copyWith(
      {List<Episode> episodes, bool hasReachedMax, int nextPage}) {
    return EpisodesListLoaded(
        episodes: episodes ?? this.episodes,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        nextPage: nextPage ?? this.nextPage);
  }

  @override
  List<Object> get props => [episodes, hasReachedMax];
}

class EpisodesListError extends EpisodesListState {}
