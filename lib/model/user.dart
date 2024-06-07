import 'package:domian/database/db_provider.dart';
import 'package:hive/hive.dart';
import 'base_model.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String email;
  @HiveField(2)
  String password;
  @HiveField(3)
  bool is_agent;
  @HiveField(4)
  DateTime? created_at;
  @HiveField(5)
  DateTime? updated_at;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.is_agent,
    this.created_at,
    this.updated_at,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] == null ? null : int.parse(data['id']),
      email: data['email'],
      password: data['password'],
      is_agent: data['is_agent'] == 1 ? true : false,
      created_at: DateTime.parse(data['created_at']),
      updated_at: DateTime.parse(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'is_agent': is_agent,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

class UserModel extends BaseModel {
  @override
  String table = 'user';

  getByEmail(String email) async {
    final conn = await DBProvider.db.database;
    final results =
        await conn?.execute('SELECT * FROM `$table` WHERE email="$email"');

    if (results!.numOfRows > 0) {
      return User.fromMap(results.rows.first.assoc());
    }
  }

  create(User user) async {
    final conn = await DBProvider.db.database;

    var userMap = user.toMap();

    await conn?.execute("INSERT INTO `$table` (id, email, password, is_agent, created_at, updated_at) VALUES (${userMap['id']}, '${userMap['email']}', '${userMap['password']}', '${userMap['is_agent']}', '${userMap['created_at']}', '${userMap['updated_at']}')");
  }
}
