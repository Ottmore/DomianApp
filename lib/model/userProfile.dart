import 'package:hive/hive.dart';
import 'package:domian/database/db_provider.dart';
import 'base_model.dart';

part 'userProfile.g.dart';

@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String first_name;
  @HiveField(2)
  String? last_name;
  @HiveField(3)
  String? description;
  @HiveField(4)
  String phone_number;
  @HiveField(5)
  String? date_of_birth;
  @HiveField(6)
  String? profile_image;

  UserProfile({
    required this.id,
    required this.first_name,
    this.last_name,
    this.description,
    required this.phone_number,
    this.date_of_birth,
    this.profile_image
  });

  factory UserProfile.fromMap(Map<String, dynamic> data) {
    return UserProfile(
      id: data['id'] == null ? null : int.parse(data['id']),
      first_name: data['first_name'],
      last_name: data['last_name'],
      description: data['description'],
      phone_number: data['phone_number'],
      date_of_birth: data['date_of_birth'],
      profile_image: data['profile_image'] ?? 'profile_image_placeholder.png'
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': first_name,
      'last_name': last_name,
      'description': description,
      'phone_number': phone_number,
      'date_of_birth': date_of_birth,
      'profile_image': profile_image,
    };
  }
}

class UserProfileModel extends BaseModel {
  @override
  String table = 'user_profile';

  @override
  getById(int id) async {
    Map<String, dynamic>? data = await super.getById(id);

    if (data != null) {
      return UserProfile.fromMap(data);
    }
  }

  create(UserProfile userProfile) async {
    final conn = await DBProvider.db.database;

    var userProfileMap = userProfile.toMap();

    await conn?.execute("INSERT INTO `$table` (id, first_name, last_name, description, phone_number, date_of_birth, profile_image) VALUES (${userProfileMap['id']}, '${userProfileMap['first_name']}', '${userProfileMap['last_name']}', '${userProfileMap['description']}', '${userProfileMap['phone_number']}', '${userProfileMap['date_of_birth']}', '${userProfileMap['profile_image']}')");
  }
}
