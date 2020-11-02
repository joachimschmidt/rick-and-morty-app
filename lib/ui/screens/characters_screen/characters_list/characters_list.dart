import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/ui/common/widgets/bottom_loader.dart';
import 'package:rick_and_morty_app/ui/screens/characters_screen/characters_list/bloc/bloc.dart';
import 'package:rick_and_morty_app/ui/screens/characters_screen/characters_list/characters_list_item.dart';
import 'package:rick_and_morty_app/ui/screens/navigation_screen/bloc/navigation_screen_bloc.dart';

class CharactersList extends StatefulWidget {
  @override
  _CharactersListState createState() => _CharactersListState();
}

class _CharactersListState extends State<CharactersList> {
  final _mainScrollController = ScrollController();

  CharactersListBloc _charactersListBloc;

  void _onMainScroll() {
    if (_mainScrollController.offset >=
            _mainScrollController.position.maxScrollExtent &&
        !_mainScrollController.position.outOfRange) {
      _charactersListBloc.add(ReachedBottomOfCharactersList());
    }
  }

  @override
  void initState() {
    _charactersListBloc = BlocProvider.of<CharactersListBloc>(context);
    _charactersListBloc.add(ReachedBottomOfCharactersList());
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
    return BlocBuilder<CharactersListBloc, CharactersListState>(
      builder: (BuildContext context, state) {
        if (state is InitialCharactersListState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CharactersListError) {
          return Center(
            child: Text("Could not load characters"),
          );
        }
        if (state is CharactersLoaded) {
          if (state.characters.isEmpty) {
            return Center(
              child: Text('No Characters'),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              if (index >= state.characters.length) {
                if (!state.hasReachedMax)
                  return BottomLoader();
                else
                  return Center(
                      child: Text(
                    "End of Characters",
                    style: TextStyle(fontSize: 20),
                  ));
              } else {
                return CharactersListItem(
                    state.characters[index],
                    BlocProvider.of<NavigationScreenBloc>(context)
                        .hasInternetConnection);
              }
            },
            itemCount: state.characters.length + 1,
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
