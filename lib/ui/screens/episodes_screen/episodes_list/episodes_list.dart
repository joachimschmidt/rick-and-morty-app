import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/ui/screens/episodes_screen/episodes_list/bloc/bloc.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/bloc.dart';

import '../../../common/widgets/bottom_loader.dart';
import 'bloc/episodes_list_bloc.dart';
import 'episodes_list_item.dart';

class EpisodesList extends StatefulWidget {
  const EpisodesList({Key key}) : super(key: key);

  @override
  _EpisodesListState createState() => _EpisodesListState();
}

class _EpisodesListState extends State<EpisodesList> {
  final _mainScrollController = ScrollController();

  EpisodesListBloc _episodesListBloc;

  void _onMainScroll() {
    if (_mainScrollController.offset >=
            _mainScrollController.position.maxScrollExtent &&
        !_mainScrollController.position.outOfRange) {
      _episodesListBloc.add(ReachedBottomOfEpisodesList());
    }
  }

  @override
  void initState() {
    _episodesListBloc = BlocProvider.of<EpisodesListBloc>(context);
    _episodesListBloc.add(ReachedBottomOfEpisodesList());
    _mainScrollController.addListener(_onMainScroll);
    super.initState();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodesListBloc, EpisodesListState>(
      builder: (BuildContext context, state) {
        if (state is InitialEpisodesListState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is EpisodesListError) {
          return Center(
            child: Text("Could not load episodes"),
          );
        }
        if (state is EpisodesListLoaded) {
          if (state.episodes.isEmpty) {
            return Center(
              child: Text('No Episodes'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index >= state.episodes.length) {
                if (!state.hasReachedMax)
                  return BottomLoader();
                else
                  return Center(
                      child: Text(
                    "End of episodes",
                    style: TextStyle(fontSize: 20),
                  ));
              } else {
                return EpisodesListItem(
                    state.episodes[index],
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .hasInternetConnection);
              }
            },
            itemCount: state.episodes.length + 1,
            controller: _mainScrollController,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
