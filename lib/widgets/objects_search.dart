import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:domian/model/address.dart';
import 'package:domian/model/objectProperties.dart';
import 'package:domian/services/object_service.dart';

import 'package:domian/screens/details/details_screen.dart';

import 'package:domian/constants/constants.dart';

import '../model/object.dart';

class ObjectsSearch extends StatefulWidget {
  const ObjectsSearch({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  State<ObjectsSearch> createState() => _ObjectsSearch();
}

class _ObjectsSearch extends State<ObjectsSearch> {
  bool _isLoading = true;

  List<Object> dataObject = [];

  List<Object> listObjects = [];
  List<ObjectProperties> listObjectsProperties = [];
  List<Address> listAddress = [];

  final Map<int, Future<Uint8List>> _imageCache = {};

  late Box favoriteObjectBox;

  @override
  void initState() {
    super.initState();

    widget.searchController.addListener(() {
      _onSearchChanged();
    });

    favoriteObjectBox = Hive.box('favorites');

    _loadData();
  }

  _onSearchChanged() {
    List<Object> updatedListObject = [];

    if (widget.searchController.text.length >= 3) {
      int i = -1;

      updatedListObject = dataObject
          .map((object) {
            i++;
            Address addressObject = listAddress[i];
            String address = "${addressObject.city} ${addressObject.address} ${addressObject.house_number} ${addressObject.flat_number ?? ""}".toLowerCase();

            if (address.contains(widget.searchController.text.toLowerCase())) {
              return object;
            }

            return null;
          })
          .where((element) => element != null)
          .cast<Object>()
          .toList();

      setState(() {
        listObjects = updatedListObject;
      });
    } else {
      setState(() {
          listObjects = dataObject;
      });
    }
  }

  Future<Uint8List> _getImage(int id, String imageUrl) async {
    if (!_imageCache.containsKey(id)) {
      _imageCache[id] = ObjectService().getObjectImage(id, imageUrl);
    }
    return _imageCache[id]!;
  }

  Widget _buildHouse(BuildContext context, int index) {
    Object object = listObjects[index];
    ObjectProperties objectProperties = listObjectsProperties.where((property) => property.object_id == object.id).first;
    Address address = listAddress.where((address) => address.id == object.address_id).first;

    String fullAddress = "${address.city} ${address.address} ${address.house_number} ${address.flat_number ?? ""}";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(
                object: object,
                objectProperties: objectProperties,
                address: address
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: appPadding, vertical: appPadding / 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: FutureBuilder<Uint8List>(
                      future: _getImage(object.id!, object.main_img),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Container(
                            height: 180,
                            width: double.infinity,
                            color: Colors.grey[200],
                          );
                        }
                      },
                    ),
                  ),
                  Positioned(
                    right: appPadding / 2,
                    top: appPadding / 2,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: IconButton(
                        icon: favoriteObjectBox.containsKey(object.id)
                            ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                            : const Icon(
                          Icons.favorite_border_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          if (favoriteObjectBox.containsKey(object.id)) {
                            favoriteObjectBox.delete(object.id);
                          } else {
                            favoriteObjectBox.put(object.id, true);
                          }

                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\₽${object.cost.toStringAsFixed(3)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fullAddress,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    ),
                  ],
                ),
              ),
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
    dataObject = await ObjectModel().getAll();
    var dataObjectProperties = await ObjectPropertiesModel().getAll();
    var dataAddress = await AddressModel().getAll();

    setState(() {
      listObjects = dataObject;
      listObjectsProperties = dataObjectProperties;
      listAddress = dataAddress;
      _isLoading = false;
    });
  }
}
