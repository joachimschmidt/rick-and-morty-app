import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:rick_and_morty_app/data/models/location/location.dart';

import 'gender.dart';
import 'status.dart';

part 'character.g.dart';

@HiveType(typeId: 1)
class Character extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final Status status;
  @HiveField(3)
  final String species;
  @HiveField(4)
  final String type;
  @HiveField(5)
  final Gender gender;
  @HiveField(6)
  final Location origin;
  @HiveField(7)
  final Location location;
  @HiveField(8)
  String image;
  @HiveField(9)
  final List episodes;
  @HiveField(10)
  final String url;

  Character(
      {@required this.id,
      @required this.name,
      @required this.status,
      @required this.species,
      @required this.type,
      @required this.gender,
      @required this.origin,
      @required this.location,
      @required this.image,
      @required this.url,
      @required this.episodes});

  static Gender genderFromJson(String json) {
    switch (json) {
      case "Unknown":
        return Gender.Unknown;
        break;
      case "Male":
        return Gender.Male;
        break;
      case "Female":
        return Gender.Female;
        break;
      default:
        return Gender.Genderless;
        break;
    }
  }

  static Status statusFromJson(String json) {
    switch (json) {
      case "Alive":
        return Status.Alive;
        break;
      case "Dead":
        return Status.Dead;
        break;
      default:
        return Status.Unknown;
        break;
    }
  }

  Character.fromJsonShort(
    Map<String, dynamic> json,
  )   : name = json['name'],
        id = json['id'],
        url = json['url'],
        species = json['species'],
        type = json['type'],
        image = json['image'],
        status = statusFromJson(json['status']),
        origin =
            Location(name: json['origin']['name'], url: json['origin']['url']),
        location = Location(
            name: json['location']['name'], url: json['location']['url']),
        episodes = json['episode'],
        gender = genderFromJson(json['gender']);
}
