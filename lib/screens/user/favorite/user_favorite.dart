import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:domian/services/object_service.dart';
import 'package:domian/screens/details/details_screen.dart';
import 'package:domian/model/address.dart';
import 'package:domian/model/object.dart';
import 'package:domian/model/objectProperties.dart';
import 'package:domian/widgets/bottom_app_bar.dart';

import 'package:domian/constants/constants.dart';

class UserFavorite extends StatefulWidget {
  const UserFavorite({Key? key}) : super(key: key);

  @override
  _UserFavoriteState createState() => _UserFavoriteState();
}

class _UserFavoriteState extends State<UserFavorite> {
  bool _isLoading = true;
  late Box favoriteObjectBox;
  List<Object> listObjects = [];
  List<ObjectProperties> listObjectsProperties = [];
  List<Address> listAddress = [];
  final Map<int, Future<Uint8List>> _imageCache = {};

  @override
  void initState() {
    super.initState();
    favoriteObjectBox = Hive.box('favorites');
    _loadData();
  }

  Future<Uint8List> _getImage(int id, String imageUrl) async {
    if (!_imageCache.containsKey(id)) {
      _imageCache[id] = ObjectService().getObjectImage(id, imageUrl);
    }
    return _imageCache[id]!;
  }

  Widget _buildHouse(BuildContext context, int index) {
    Object object = listObjects[index];
    ObjectProperties objectProperties = listObjectsProperties
        .firstWhere((property) => property.object_id == object.id);
    Address address = listAddress.firstWhere((address) => address.id == object.address_id);

    String fullAddress =
        "${address.city} ${address.address} ${address.house_number} ${address.flat_number ?? ""}";

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Избранное',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: listObjects.length,
          itemBuilder: (context, index) {
            return _buildHouse(context, index);
          },
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(),
    );
  }

  _loadData() async {
    final List<int> objectIds =
    favoriteObjectBox.keys.cast<int>().toList(); // Ensure keys are integers

    List<Object> objects = await ObjectModel().getByIds(objectIds);
    List<int> addressIds = objects.map((object) => object.address_id).toList();

    List<ObjectProperties> dataObjectProperties =
    await ObjectPropertiesModel().getByIds(objectIds);
    List<Address> dataAddress = await AddressModel().getByIds(addressIds);

    setState(() {
      listObjects = objects;
      listObjectsProperties = dataObjectProperties;
      listAddress = dataAddress;
      _isLoading = false;
    });
  }
}