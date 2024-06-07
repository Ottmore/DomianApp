import 'package:domian/database/db_provider.dart';

import 'base_model.dart';

class Address {
  int? id;
  String city;
  String address;
  String house_number;
  int? flat_number;

  Address({
    required this.id,
    required this.city,
    required this.address,
    required this.house_number,
    this.flat_number
  });

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
      id: data['id'] == null ? null : int.parse(data['id']),
      city: data['city'],
      address: data['address'],
      house_number: data['house_number'],
      flat_number: data['flat_number'] == null ? null : int.parse(data['flat_number']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'city': city,
      'address': address,
      'house_number': house_number,
      'flat_number': flat_number,
    };
  }
}

class AddressModel extends BaseModel {
  @override
  String table = 'address';

  @override
  getAll() async {
    var data = await super.getAll();
    List<Address> listAddress = [];

    if (data != null) {
      for (var address in data) {
        listAddress.add(Address.fromMap(address.assoc()));
      }
    }

    return listAddress;
  }
}
