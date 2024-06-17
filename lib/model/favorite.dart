import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 2)
class Favorite extends HiveObject {
  @HiveField(0)
  int objectId;

  @HiveField(1)
  bool isFavorite;

  Favorite({
    required this.objectId,
    required this.isFavorite
  });
}
