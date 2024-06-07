import 'package:domian/model/address.dart';
import 'package:domian/model/objectProperties.dart';
import 'package:flutter/material.dart';
import 'package:domian/model/object.dart';
import 'package:domian/screens/details/components/bottom_buttons.dart';
import 'package:domian/screens/details/components/carousel_images.dart';
import 'package:domian/screens/details/components/details_app_bar.dart';
import 'package:domian/screens/details/components/house_details.dart';

class DetailsScreen extends StatefulWidget {
  final Object object;
  final ObjectProperties objectProperties;
  final Address address;

  const DetailsScreen({
    Key? key,
    required this.object,
    required this.objectProperties,
    required this.address,
  }) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CarouselImages(widget.object.more_img),
                  CustomAppBar(object: widget.object),
                ],
              ),
              HouseDetails(
                  widget.object, widget.objectProperties, widget.address),
            ],
          ),
          BottomButtons(),
        ],
      ),
    );
  }
}
