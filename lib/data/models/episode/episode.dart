import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'episode.g.dart';

@HiveType(typeId: 2)
class Episode extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String airDate;
  @HiveField(3)
  final String code;
  @HiveField(4)
  final List characters;
  @HiveField(5)
  final String url;

  Episode(
      {@required this.id,
      @required this.url,
      @required this.name,
      @required this.airDate,
      @required this.code,
      @required this.characters});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

  Episode.fromJsonShort(
    Map<String, dynamic> json,
  )   : name = json['name'],
        id = json['id'],
        url = json['url'],
        airDate = json['air_date'],
        code = json['episode'],
        characters = json['characters'];
}
