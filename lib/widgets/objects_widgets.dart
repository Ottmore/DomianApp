import 'package:domian/model/address.dart';
import 'package:domian/model/objectProperties.dart';
import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';
import 'package:domian/model/object.dart';
import 'package:domian/screens/details/details_screen.dart';

import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class Houses extends StatefulWidget {
  const Houses({super.key});

  @override
  _HousesState createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  bool _isLoading = true;

  List<Object> listObjects = [];
  List<ObjectProperties> listObjectsProperties = [];
  List<Address> listAddress = [];

  bool isFav = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Widget _buildHouse(BuildContext context, int index) {
    Size size = MediaQuery.of(context).size;
    Object object = listObjects[index];
    ObjectProperties objectProperties = listObjectsProperties[index];
    Address address = listAddress[index];

    String fullAddress =
        "${address.address} ${address.house_number} ${address.flat_number ?? ""}";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(
                object: object,
                objectProperties: objectProperties,
                address: address),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: appPadding, vertical: appPadding / 2),
        child: Container(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image(
                      height: 180,
                      width: size.width,
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/${object.main_img}'),
                    ),
                  ),
                  Positioned(
                    right: appPadding / 2,
                    top: appPadding / 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        icon: isFav
                            ? const Icon(
                                Icons.favorite_rounded,
                                color: red,
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
                  ),
                  /* ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.green)),
                    child: const Text('Select File Image'),
                    onPressed: () {
                      getImages();
                    },
                  ),
      */
                ],
              ),
              Row(
                children: [
                  Text(
                    '\₽${object.cost.toStringAsFixed(3)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      fullAddress,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15, color: black.withOpacity(0.4)),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${objectProperties.rooms} Комнат / ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${objectProperties.bathrooms} Ванных / ',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${objectProperties.area} м²',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Expanded(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: listObjects.length,
          itemBuilder: (context, index) {
            return _buildHouse(context, index);
          },
        ),
      );
    }
  }

  _loadData() async {
    var dataObject = await ObjectModel().getAll();
    var dataObjectProperties = await ObjectPropertiesModel().getAll();
    var dataAddress = await AddressModel().getAll();

    setState(() {
      listObjects = dataObject;
      listObjectsProperties = dataObjectProperties;
      listAddress = dataAddress;
    });

    _isLoading = false;
  }

  late Uint8List fileImage;
  late Uint8List selectedImages;

}
