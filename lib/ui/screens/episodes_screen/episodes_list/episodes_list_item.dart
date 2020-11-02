import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/data/models/episode/episode.dart';
import 'package:rick_and_morty_app/ui/screens/detailed_episode_screen/detailed_episode_screen.dart';

class EpisodesListItem extends StatelessWidget {
  final Episode episode;
  final bool online;

  EpisodesListItem(this.episode, this.online);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailedEpisodeScreen(
                    episode: episode,
                    online: online,
                  )),
        );
      },
      child: Container(
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      episode.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(episode.code)
                  ],
                ),
              ),
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
