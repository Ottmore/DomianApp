import 'package:domian/database/db_provider.dart';

import 'base_model.dart';

class Reviews{

 int id;
 int user_id;
 String? text;
 int rating;
 DateTime? created_at;
 DateTime? updated_at;

 Reviews({

   required this.id,
   required this.user_id,
   this.text,
   required this.rating,
   this.created_at,
   this.updated_at,

});

 factory Reviews.fromMap(Map<String, dynamic> data) {
   return Reviews(
     id: int.parse(data['id']),
     user_id: int.parse(data['user_id']),
     text: data['text'],
     rating: data['rating'],
     created_at: DateTime.parse(data['created_at']),
     updated_at: DateTime.parse(data['updated_at']),
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
   };
 }
}

  class ReviewsModel extends BaseModel {
    @override
    String table = 'reviews';

    @override
    getAll() async {
      var data = await super.getAll();
      List<Reviews> reviews = [];

      if (data != null) {
        for (var reviews in data) {
          reviews.add(Reviews.fromMap(reviews.assoc()));
        }
      }

      return reviews;
    }


  }