import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';

class BottomButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: appPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {

            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: size.width * 0.4,
              height: 60,
              decoration: BoxDecoration(
                color: cdomian,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: cdomian.withOpacity(0.6),
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_rounded, color: white),
                  Text(
                    ' Написать',
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {

            },
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: size.width * 0.4,
              height: 60,
              decoration: BoxDecoration(
                color: cdomian,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: cdomian.withOpacity(0.6),
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call_rounded, color: white),
                  Text(
                    ' Позвонить',
                    style: TextStyle(
                      color: white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}