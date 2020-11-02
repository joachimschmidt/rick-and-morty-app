import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/core/utils/parser.dart';
import 'package:rick_and_morty_app/data/models/character/character.dart';
import 'package:rick_and_morty_app/data/models/episode/episode.dart';
import 'package:rick_and_morty_app/data/repository/local_data_repository.dart';
import 'package:rick_and_morty_app/data/repository/remote_data_repository.dart';
import 'package:rick_and_morty_app/ui/screens/episodes_screen/episodes_list/episodes_list_item.dart';

class DetailedCharacterScreen extends StatefulWidget {
  final Character character;
  final online;

  const DetailedCharacterScreen(
      {Key key, @required this.character, this.online})
      : super(key: key);

  @override
  _DetailedCharacterScreenState createState() =>
      _DetailedCharacterScreenState();
}

class _DetailedCharacterScreenState extends State<DetailedCharacterScreen> {
  List<Episode> episodes = List<Episode>();
  bool inFavorites = false;
  Box<int> favoriteCharacters;
  bool loaded = false;

  void getEpisodes() async {
    List<int> episodeIDs = Parser.parseEpisodeList(
        widget.character.episodes.cast<String>().toList());
    var res;
    if (widget.online) {
      res = await RemoteDataRepository.getAllSpecifiedEpisodes(episodeIDs);
    } else {
      res = await LocalDataRepository.getAllSpecifiedEpisodes(episodeIDs);
    }
    setState(() {
      res.fold((l) => print("error"), (r) => episodes = r.data);
      loaded = true;
    });
  }

  fabPressed() {
    setState(() {
      inFavorites = !inFavorites;
      if (favoriteCharacters.containsKey(widget.character.id)) {
        favoriteCharacters.delete(widget.character.id);
        return;
      }
      favoriteCharacters.put(widget.character.id, widget.character.id);
    });
  }

  @override
  void initState() {
    getEpisodes();
    favoriteCharacters = Hive.box('favorites');
    inFavorites = favoriteCharacters.containsKey(widget.character.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Stack(
              children: [
                Text(
                  widget.character.name,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1
                          ..color = Colors.black,
                      ),
                ),
                Text(
                  widget.character.name,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white),
                )
              ],
            ),
            expandedHeight: 400,
            flexibleSpace: Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(widget.character.image),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Name:",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Species:",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Gender:",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Status:",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Location:",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "Origin:",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                            widget.character.name,
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                          Center(
                              child: Text(
                            widget.character.species,
                            style: Theme.of(context).textTheme.subtitle1,
                          )),
                          Center(
                              child: Text(
                                  widget.character.gender
                                      .toString()
                                      .split('.')
                                      .last,
                                  style:
                                      Theme.of(context).textTheme.subtitle1)),
                          Center(
                              child: Text(
                                  widget.character.status
                                      .toString()
                                      .split('.')
                                      .last,
                                  style:
                                      Theme.of(context).textTheme.subtitle1)),
                          Center(
                              child: Text(widget.character.location.name,
                                  style:
                                      Theme.of(context).textTheme.subtitle1)),
                          Center(
                              child: Text(widget.character.origin.name,
                                  style:
                                      Theme.of(context).textTheme.subtitle1)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Episodes with character:",
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                )
              ],
            ),
          ),
          loaded
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        EpisodesListItem(episodes[index], widget.online),
                    childCount: episodes.length,
                  ),
                )
              : SliverToBoxAdapter()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fabPressed,
        child: Icon(
            inFavorites ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart),
      ),
    );
  }
}
