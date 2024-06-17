import 'dart:convert';

import 'package:domian/database/db_provider.dart';
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
      forSale: int.parse(data['forSale']) == 1 ? true : false,
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

  getByIds(List<int> ids) async {
    final conn = await DBProvider.db.database;

    var data = await conn?.execute('SELECT * FROM `$table` WHERE id IN (${ids.join(',')})');
    List<Object> objects = [];

    if (data!.numOfRows > 0) {
      for (var object in data.rows) {
        objects.add(Object.fromMap(object.assoc()));
      }
    }

    return objects;
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

  getByCity(String city) async {
    final conn = await DBProvider.db.database;

    var data = await conn?.execute('SELECT `$table`.id, `$table`.user_id, `$table`.address_id, `$table`.cost, `$table`.description, `$table`.object_type, `$table`.building_type, `$table`.forSale, `$table`.main_img, `$table`.more_img, `$table`.created_at, `$table`.updated_at FROM `$table` INNER JOIN `address` ON `$table`.address_id=`address`.id WHERE `address`.city="$city"');
    List<Object> objects = [];

    if (data!.numOfRows > 0) {
      for (var object in data.rows) {
        objects.add(Object.fromMap(object.assoc()));
      }
    }

    return objects;
  }

  create(Object object) async {
    final conn = await DBProvider.db.database;

    var objectMap = object.toMap();

    await conn?.execute("INSERT INTO `$table` (id,user_id,address_id,cost,description,building_type,forSale,main_img,more_img,created_at,updated_at) VALUES (${objectMap['id']}, '${objectMap['user_id']}', '${objectMap['address_id']}', '${objectMap['cost']}','${objectMap['description']}','${objectMap['object_type']}','${objectMap['building_type']}','${objectMap['forSale']}','${objectMap['main_img']}','${objectMap['more_img']}', '${objectMap['created_at']}', '${objectMap['updated_at']}')");
  }

  getObjectUser(int objectId) async {
    final conn = await DBProvider.db.database;

    var data = await conn?.execute('SELECT `user_profile`.first_name, `user_profile`.last_name, `user_profile`.description, `user_profile`.phone_number, `user_profile`.date_of_birth, `user_profile`.profile_image FROM `$table` INNER JOIN `user_profile` ON `$table`.user_id=`user_profile`.id WHERE `$table`.id="$objectId"');

    if (data!.numOfRows > 0) {
      return data.rows.first.assoc();
    }

    return Null;
  }
}