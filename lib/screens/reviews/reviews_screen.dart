import 'package:domian/constants/constants.dart';
import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  _ReviewsScreenState createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Алексей Петров',
      'review': 'Отличный агенство! Очень доволен их работой.',
      'rating': 5,
    },
    {
      'name': 'Мария Иванова',
      'review': 'Хорошее агенство, но мало объектов подходящих под мои критерии.',
      'rating': 4,
    },
  ];

  void _addReview(String name, String review, int rating) {
    setState(() {
      _reviews.add({'name': name, 'review': review, 'rating': rating});
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Отзывы'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(review['name']),
                      subtitle: Text(review['review']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (i) {
                          return Icon(
                            i < review['rating'] ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showAddReviewDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: cdomian,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                elevation: 5,
              ),
              icon: Icon(Icons.add, color: Colors.white),
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
}

class AddReviewDialog extends StatefulWidget {
  final Function(String, String, int) onSubmit;

  const AddReviewDialog({super.key, required this.onSubmit});

  @override
  _AddReviewDialogState createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  int _rating = 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Добавить отзыв'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Имя'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите ваше имя';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _reviewController,
              decoration: InputDecoration(labelText: 'Отзыв'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите ваш отзыв';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Text('Оценка'),
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
                _nameController.text,
                _reviewController.text,
                _rating,
              );
              Navigator.of(context).pop();
            }
          },
          child: Text('Добавить'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Отмена'),
        ),
      ],
    );
  }
}