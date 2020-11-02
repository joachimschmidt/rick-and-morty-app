import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';
import 'package:rick_and_morty_app/ui/screens/detailed_character_screen/detailed_character_screen.dart';

class CharactersListItem extends StatelessWidget {
  final Character character;
  final bool online;

  CharactersListItem(this.character, this.online);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedCharacterScreen(
                    character: character,
                    online: online,
                  )),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: online
                            ? NetworkImage(character.image)
                            : AssetImage("resources/no_image.png"))),
              ),
              Expanded(
                  child: Text(character.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1)),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
