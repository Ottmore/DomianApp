import 'package:domian/database/db_provider.dart';
import 'base_model.dart';

class Review {
  int? id;
  int user_id;
  String? text;
  int rating;
  DateTime? created_at;
  DateTime? updated_at;

  String? first_name;
  String? last_name;

  Review({
    this.id,
    required this.user_id,
    this.text,
    required this.rating,
    this.created_at,
    this.updated_at,
    this.first_name,
    this.last_name,
  });

  factory Review.fromMap(Map<String, dynamic> data) {
    return Review(
      id: data['id'] == null ? null : int.parse(data['id']),
      user_id: int.parse(data['user_id']),
      text: data['text'],
      rating: int.parse(data['rating']),
      created_at: DateTime.parse(data['created_at']),
      updated_at: DateTime.parse(data['updated_at']),
      first_name: data['first_name'],
      last_name: data['last_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'text': text,
      'rating': rating,
      'created_at': created_at,
      'updated_at': updated_at,
      'first_name': first_name,
      'last_name': last_name,
    };
  }
}

class ReviewModel extends BaseModel {
  @override
  String table = 'reviews';

  @override
  getAll() async {
    final conn = await DBProvider.db.database;

    var data = await conn?.execute('SELECT `$table`.user_id, `$table`.text, `$table`.rating, `$table`.created_at, `$table`.updated_at, user_profile.first_name, user_profile.last_name FROM `$table` INNER JOIN `user_profile` ON `$table`.user_id=`user_profile`.id');
    List<Review> reviews = [];

    if (data!.numOfRows > 0) {
      for (var review in data.rows) {
        reviews.add(Review.fromMap(review.assoc()));
      }
    }

    return reviews;
  }

  create(Review review) async {
    final conn = await DBProvider.db.database;

    var reviewMap = review.toMap();

    await conn?.execute("INSERT INTO `$table` (id, user_id, text, rating, created_at, updated_at) VALUES (${reviewMap['id']}, '${reviewMap['user_id']}', '${reviewMap['text']}', '${reviewMap['rating']}', '${reviewMap['created_at']}', '${reviewMap['updated_at']}')");
  }
}
