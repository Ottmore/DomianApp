import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: appPadding * 2,
      ),
      child: Container(
        height: size.height * 0.12,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Город', style: TextStyle(
                    color: black.withOpacity(0.4),
                    fontSize: 18,
                  ),),
                  SizedBox(height: size.height * 0.01),
                  const Text('Ростов на Дону', style: TextStyle(
                      color: black,
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}