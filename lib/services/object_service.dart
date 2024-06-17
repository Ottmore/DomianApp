import 'dart:io';
import 'dart:typed_data';
import 'package:dartssh2/dartssh2.dart';
import 'package:domian/model/address.dart';
import 'package:domian/model/objectProperties.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:domian/model/object.dart';

class ObjectService {
  Future<Uint8List> getObjectImage(int objectId, String fileName) async {
    final socket = await SSHSocket.connect(
        dotenv.env['SFTP_HOST']!,
        int.parse(dotenv.env['SFTP_PORT']!)
    );

    final client = SSHClient(
      socket,
      username: dotenv.env['SFTP_USERNAME']!,
      onPasswordRequest: () => dotenv.env['SFTP_PASSWORD'],
    );

    final sftp = await client.sftp();
    final item = await sftp.open('${dotenv.env['SFTP_PATH']}/objects/$objectId/$fileName');
    final content = await item.readBytes();

    client.close();
    await client.done;

    return content;
  }

  Future<Map<String, dynamic>> addObject(String city,String address,String house_number,int? flat_number,int rooms,int? floor,int? total_floor,int? floor_in_object,double area,double? room_area,double? living_area,double? kitchen_area,String? balcony_or_loggia,int? bathrooms,int? toilet,String? heating,String? layout,String? window_view,String? renovation,int? elevators,bool new_building,bool garage,int user_id,int address_id,double cost,String description,String? object_type,String? building_type,bool forSale,String main_img,List<String> more_img,DateTime? created_at,DateTime? updated_at) async {

    Map<String, dynamic> AddressMap = {
      'city': city,
      'address': address,
      'house_number': house_number,
      'flat_number': flat_number,
    };

    Map<String, dynamic> ObjectPropertiesMap = {
      'rooms': rooms,
      'floor': floor,
      'total_floor': total_floor,
      'floor_in_object': floor_in_object,
      'area': area,
      'room_area': room_area,
      'living_area': living_area,
      'kitchen_area': kitchen_area,
      'balcony_or_loggia': balcony_or_loggia,
      'bathrooms': bathrooms,
      'toilet': toilet,
      'heating': heating,
      'layout': layout,
      'window_view': window_view,
      'renovation': renovation,
      'elevators': elevators,
      'new_building': new_building,
      'garage': garage,
    };

    Map<String, dynamic> ObjectMap = {
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

    AddressModel().create(Address.fromMap(AddressMap));
    ObjectPropertiesModel().create(ObjectProperties.fromMap(ObjectPropertiesMap));
    ObjectModel().create(Object.fromMap(ObjectMap));

    Object? createdObject = await ObjectModel().getById(address_id);

    return {
      'Object': createdObject,
      'message': 'Успешная регистрация',
    };
  }

  saveObjectImage(String filePath, String fileName, String objectId) async {
    final socket = await SSHSocket.connect(
        dotenv.env['SFTP_HOST']!,
        int.parse(dotenv.env['SFTP_PORT']!)
    );

    final client = SSHClient(
      socket,
      username: dotenv.env['SFTP_USERNAME']!,
      onPasswordRequest: () => dotenv.env['SFTP_PASSWORD'],
    );

    final sftp = await client.sftp();

    await sftp.mkdir('${dotenv.env['SFTP_PATH']}/objects/$objectId');

    final file = await sftp.open('${dotenv.env['SFTP_PATH']}/objects/$objectId/$fileName', mode: SftpFileOpenMode.create | SftpFileOpenMode.write);
    await file.write(File(filePath).openRead().cast());

    client.close();
    await client.done;
  }

}