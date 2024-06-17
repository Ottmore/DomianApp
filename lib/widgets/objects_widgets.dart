import 'dart:typed_data';

import 'package:domian/model/address.dart';
import 'package:domian/model/objectProperties.dart';
import 'package:domian/services/object_service.dart';
import 'package:flutter/material.dart';
import 'package:domian/constants/constants.dart';
import 'package:domian/model/object.dart';
import 'package:domian/screens/details/details_screen.dart';
import 'package:hive/hive.dart';

class Houses extends StatefulWidget {
  const Houses({super.key, required this.city, required this.category});

  final String city;
  final String category;

  @override
  _HousesState createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  bool _isLoading = true;

  List<Object> dataObject = [];

  List<Object> listObjects = [];
  List<ObjectProperties> listObjectsProperties = [];
  List<Address> listAddress = [];

  final Map<int, Future<Uint8List>> _imageCache = {};

  late Box favoriteObjectBox;

  late String _category;
  late String _city;

  @override
  void initState() {
    super.initState();

    _category = widget.category;
    _city = widget.city;

    favoriteObjectBox = Hive.box('favorites');

    _loadData(_city);
  }

  @override
  void didUpdateWidget(Houses oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.city != _city) {
      _isLoading = true;
      _loadData(widget.city);
      _city = widget.city;
    }

    _category = widget.category;

    updateFilter();
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

    String fullAddress = "${address.address} ${address.house_number} ${address.flat_number ?? ""}";

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

  updateFilter() {
    List<Object> updatedListObject = [];

    switch (_category) {
      case '<4000000\₽':
        updatedListObject = dataObject
            .map((object) => object.cost < 4000000 ? object : null)
            .where((element) => element != null)
            .cast<Object>()
            .toList();
        break;
      case 'Продается':
        updatedListObject = dataObject
            .map((object) => object.forSale ? object : null)
            .where((element) => element != null)
            .cast<Object>()
            .toList();
        break;
      case '<3 Комнат':
        int i = -1;

        updatedListObject = dataObject
            .map((object) {
          i++;
          return listObjectsProperties[i].rooms < 3 ? object : null;
        })
            .where((element) => element != null)
            .cast<Object>()
            .toList();
        break;
      case 'Гараж':
        int i = -1;

        updatedListObject = dataObject
            .map((object) {
          i++;
          return listObjectsProperties[i].garage ? object : null;
        })
            .where((element) => element != null)
            .cast<Object>()
            .toList();
        break;
      default:
        updatedListObject = dataObject;
        break;
    }

    setState(() {
      listObjects = updatedListObject;
    });
  }

  _loadData(String city) async {
    dataObject = await ObjectModel().getByCity(city);

    List<int> objectIds = [];
    List<int> addressIds = [];

    for (Object object in dataObject) {
      objectIds.add(object.id!);
      addressIds.add(object.address_id);
    }

    var dataObjectProperties = await ObjectPropertiesModel().getByIds(objectIds);
    var dataAddress = await AddressModel().getByIds(addressIds);

    setState(() {
      listObjects = dataObject;
      listObjectsProperties = dataObjectProperties;
      listAddress = dataAddress;
      _isLoading = false;
    });

    if (_category != '') {
      updateFilter();
    }
  }
}
