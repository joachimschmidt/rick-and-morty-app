import 'package:hive/hive.dart';

part 'gender.g.dart';

@HiveType(typeId: 5)
enum Gender {
  @HiveField(0)
  Female,
  @HiveField(1)
  Male,
  @HiveField(2)
  Genderless,
  @HiveField(3)
  Unknown
}
