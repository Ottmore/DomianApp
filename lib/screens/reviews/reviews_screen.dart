import 'package:domian/constants/constants.dart';
import 'package:domian/model/review.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _isLoading = true;

  List<Review> listReviews = [];

  late Box userBox;
  late Box userProfileBox;

  late Map<dynamic, dynamic> user;
  late Map<dynamic, dynamic> userProfile;

  void _addReview(String review, int rating) {
    Map<String, dynamic> reviewMap = {
      'user_id': user['id'].toString(),
      'text': review,
      'rating': rating.toString(),
      'created_at': DateTime.now().toString(),
      'updated_at': DateTime.now().toString(),
      'first_name': userProfile['first_name'],
      'last_name': userProfile['last_name'],
    };

    ReviewModel().create(Review.fromMap(reviewMap));

    setState(() {
      listReviews.add(Review.fromMap(reviewMap));
    });
  }

  void _showAddReviewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddReviewDialog(onSubmit: _addReview);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('user');
    userProfileBox = Hive.box('user_profile');

    if (userProfileBox.length > 0) {
      user = userBox.getAt(0);
      userProfile = userProfileBox.getAt(0);
    }

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отзывы', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listReviews.length,
                itemBuilder: (context, index) {
                  final review = listReviews[index];
                  final userName = '${review.first_name} ${review.last_name}';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        review.text ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          return Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAddReviewDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: cdomian,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                elevation: 5,
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Добавить отзыв',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadData() async {
    List<Review> dataReviews = await ReviewModel().getAll();

    setState(() {
      listReviews = dataReviews;
      _isLoading = false;
    });
  }
}

class AddReviewDialog extends StatefulWidget {
  final Function(String, int) onSubmit;

  const AddReviewDialog({super.key, required this.onSubmit});

  @override
  _AddReviewDialogState createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Добавить отзыв'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _reviewController,
              decoration: const InputDecoration(
                labelText: 'Отзыв'
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите ваш отзыв';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text('Оценка'),
            DropdownButtonFormField<int>(
              value: _rating,
              onChanged: (value) {
                setState(() {
                  _rating = value!;
                });
              },
              items: List.generate(5, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSubmit(
                _reviewController.text,
                _rating,
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Добавить'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Отмена'),
        ),
      ],
    );
  }
}
