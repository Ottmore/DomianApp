import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';

import 'package:domian/model/object.dart';

class CustomAppBar extends StatefulWidget {
  final Object object;

  const CustomAppBar({super.key, required this.object});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(
        left: appPadding,
        right: appPadding,
        top: appPadding ,
      ),
      child: Container(
        height: size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Icon(Icons.arrow_back_rounded,color: black),
              ),
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: white,
                  border: Border.all(color: white.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: IconButton(
                icon: isFav
                    ? const Icon(
                  Icons.favorite_rounded,
                  color: cdomian,
                )
                    : const Icon(
                  Icons.favorite_border_rounded,
                  color: black,
                ),
                onPressed: () {
                  setState(() {
                    isFav = !isFav;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}