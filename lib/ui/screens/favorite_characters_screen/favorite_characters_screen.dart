import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';
import 'package:rick_and_morty_app/data/repository/local_data_repository.dart';
import 'package:rick_and_morty_app/ui/screens/characters_screen/characters_list/characters_list_item.dart';

class FavoriteCharactersScreen extends StatefulWidget {
  final bool online;

  const FavoriteCharactersScreen({Key key, this.online}) : super(key: key);

  @override
  _FavoriteCharactersScreenState createState() =>
      _FavoriteCharactersScreenState();
}

class _FavoriteCharactersScreenState extends State<FavoriteCharactersScreen> {
  List<Character> characters = List<Character>();
  Box<int> favoriteCharacters;

  @override
  void initState() {
    favoriteCharacters = Hive.box<int>('favorites');
    loadFavoriteCharacters();
    super.initState();
  }

  void loadFavoriteCharacters() async {
    List<int> characterIDs = favoriteCharacters.values.toList();
    var res = await LocalDataRepository.getAllSpecifiedCharacters(characterIDs);
    setState(() {
      res.fold((l) => print("error"), (r) => characters = r.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Characters"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CharactersListItem(characters[index], widget.online);
        },
        itemCount: characters.length,
      ),
    );
  }
}
