import 'dart:convert';

import 'base_model.dart';

class Object {
  int? id;
  int user_id;
  int address_id;
  double cost;
  String description;
  String? object_type;
  String? building_type;
  bool forSale;
  String main_img;
  List<String> more_img;
  DateTime? created_at;
  DateTime? updated_at;

  Object({
    this.id,
    required this.user_id,
    required this.address_id,
    required this.cost,
    required this.description,
    this.object_type,
    this.building_type,
    required this.forSale,
    required this.main_img,
    required this.more_img,
    this.created_at,
    this.updated_at,
  });

  factory Object.fromMap(Map<String, dynamic> data) {
    return Object(
      id: data['id'] == null ? null : int.parse(data['id']),
      user_id: int.parse(data['user_id']),
      address_id: int.parse(data['address_id']),
      cost: double.parse(data['cost']),
      description: data['description'],
      object_type: data['object_type'],
      building_type: data['building_type'],
      forSale: data['forSale'] == 1 ? true : false,
      main_img: data['main_img'],
      more_img: data['more_img'] == null ? [] : json.decode(data['more_img']).cast<String>().toList(),
      created_at: DateTime.parse(data['created_at']),
      updated_at: DateTime.parse(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'address_id': address_id,
      'cost': cost,
      'description': description,
      'object_type': object_type,
      'building_type': building_type,
      'forSale': forSale,
      'main_img': main_img,
      'more_img': more_img,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}

class ObjectModel extends BaseModel {
  @override
  String table = 'object';

  @override
  getById(int id) async {
    Map<String, dynamic>? data = await super.getById(id);

    if (data != null) {
      return Object.fromMap(data);
    }
  }

  @override
  getAll() async {
    var data = await super.getAll();
    List<Object> objects = [];

    if (data != null) {
      for (var object in data) {
        objects.add(Object.fromMap(object.assoc()));
      }
    }

    return objects;
  }
}