import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';

class CarouselImages extends StatefulWidget {

  final List<String> imagesListUrl;

  CarouselImages(this.imagesListUrl, {super.key});

  @override
  _CarouselImagesState createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    List<AssetImage> images = [];

    for (String imageUrl in widget.imagesListUrl) {
      images.add(AssetImage('assets/images/$imageUrl'));
    }

    return SizedBox(
      height: size.height * 0.35,
      child: AnotherCarousel(
        dotSize: 5,
        dotBgColor: Colors.transparent,
        autoplay: false,
        images: images,
      ),
    );
  }
}
