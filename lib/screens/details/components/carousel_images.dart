import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:domian/services/object_service.dart';
import 'package:flutter/material.dart';

class CarouselImages extends StatefulWidget {
  CarouselImages({super.key, required this.objectId, required this.imagesListUrl});

  final int objectId;
  final List<String> imagesListUrl;

  @override
  _CarouselImagesState createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  bool _isLoading = true;

  List<ImageProvider> images = [];

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  _loadData() async {
    for (String imageUrl in widget.imagesListUrl) {
      var image = await ObjectService().getObjectImage(widget.objectId, imageUrl);

      images.add(MemoryImage(image));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.35,
      child: _isLoading == false
          ? AnotherCarousel(
              dotSize: 5,
              dotBgColor: Colors.transparent,
              autoplay: false,
              images: images,
            )
          : Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
    );
  }
}
