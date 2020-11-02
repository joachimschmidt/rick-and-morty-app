import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/core/utils/parser.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';
import 'package:rick_and_morty_app/data/models/location/location.dart';
import 'package:rick_and_morty_app/data/repository/local_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/remote_data_repository.dart';
import 'package:rick_and_morty_app/ui/screens/characters_screen/characters_list/characters_list_item.dart';

class DetailedLocationScreen extends StatefulWidget {
  final Location location;
  final bool online;

  const DetailedLocationScreen({Key key, this.location, this.online})
      : super(key: key);

  @override
  _DetailedLocationScreenState createState() => _DetailedLocationScreenState();
}

class _DetailedLocationScreenState extends State<DetailedLocationScreen> {
  List<Character> characters = List<Character>();

  void getCharacters() async {
    List<int> characterIDs = Parser.parseCharacterList(
        widget.location.residents.cast<String>().toList());
    var res;
    if (widget.online) {
      res = await RemoteDataRepository.getAllSpecifiedCharacters(characterIDs);
    } else {
      res = await LocalDataRepository.getAllSpecifiedCharacters(characterIDs);
    }
    setState(() {
      res.fold((l) => print("error"), (r) => characters = r.data);
    });
  }

  @override
  void initState() {
    getCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.name),
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
