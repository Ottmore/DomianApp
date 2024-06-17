import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, required this.updateCategory});

  final Function updateCategory;

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int selectedCategoryIndex = -1;

  List<String> categoryList = [
    '<4000000\₽',
    'Продается',
    '<3 Комнат',
    'Гараж'
  ];

  Widget _buildCategory(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedCategoryIndex == index) {
            selectedCategoryIndex = -1;
            widget.updateCategory("");
            return;
          }

          selectedCategoryIndex = index;
          widget.updateCategory(categoryList[index]);
        });
      },
      child: Padding(
        padding: EdgeInsets.only(right: appPadding / 3),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: appPadding / 2),
          decoration: BoxDecoration(
            color: selectedCategoryIndex == index
                ? cdomian
                : black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              categoryList[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedCategoryIndex == index ? white : black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        top: appPadding / 4,
        bottom: appPadding,
      ),
      child: Container(
        height: size.height * 0.05,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: categoryList.length,
          itemBuilder: (context, index) {
            return _buildCategory(context, index);
          },
        ),
      ),
    );
  }
}
