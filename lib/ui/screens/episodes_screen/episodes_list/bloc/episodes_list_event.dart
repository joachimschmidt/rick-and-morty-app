abstract class EpisodesListEvent {}

class LoadedEpisodes extends EpisodesListEvent {}

class ReachedBottomOfEpisodesList extends EpisodesListEvent {}

class LoadingMoreEpisodes extends EpisodesListEvent {}
