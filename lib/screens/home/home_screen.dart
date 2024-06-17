import 'package:domian/widgets/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:domian/widgets/categories.dart';
import 'package:domian/screens/home/components/home_app_bar.dart';
import 'package:domian/widgets/objects_widgets.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  String _category = "";
  final Box _cityBox = Hive.box('city');
  late String _city = _cityBox.containsKey(0) ? _cityBox.getAt(0) : 'Ростов-на-Дону';

  void updateCategory(String category) => setState((){_category = category;});
  void updateCity(String city) {
    _cityBox.put(0, city);

    setState(() {
      _city = city;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              CustomAppBar(
                city: _city,
                updateCity: updateCity
              ),
              Categories(
                updateCategory: updateCategory
              ),
              Houses(
                city: _city,
                category: _category,
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
