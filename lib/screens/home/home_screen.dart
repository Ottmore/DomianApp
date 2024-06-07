import 'package:domian/widgets/bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:domian/widgets/categories.dart';
import 'package:domian/screens/home/components/home_app_bar.dart';
import 'package:domian/widgets/objects_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              CustomAppBar(),
              Categories(),
              const Houses(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
