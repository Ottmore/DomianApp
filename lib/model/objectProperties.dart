import 'base_model.dart';

class ObjectProperties {
  int? object_id;
  int rooms;
  int? floor;
  int? total_floor;
  int? floor_in_object;
  double area;
  double? room_area;
  double? living_area;
  double? kitchen_area;
  String? balcony_or_loggia;
  int? bathrooms;
  int? toilet;
  String? heating;
  String? layout;
  String? window_view;
  String? renovation;
  int? elevators;
  bool new_building;
  bool garages;

  ObjectProperties({
    this.object_id,
    required this.rooms,
    this.floor,
    this.total_floor,
    this.floor_in_object,
    required this.area,
    this.room_area,
    this.living_area,
    this.kitchen_area,
    this.balcony_or_loggia,
    this.bathrooms,
    this.toilet,
    this.heating,
    this.layout,
    this.window_view,
    this.renovation,
    this.elevators,
    required this.new_building,
    required this.garages
  });

  factory ObjectProperties.fromMap(Map<String, dynamic> data) {
    return ObjectProperties(
      object_id: data['object_id'] == null ? null : int.parse(data['object_id']),
      rooms: int.parse(data['rooms']),
      floor: int.parse(data['floor']),
      total_floor: int.parse(data['total_floor']),
      floor_in_object: int.parse(data['floor_in_object']),
      area: double.parse(data['area']),
      room_area: double.parse(data['room_area']),
      living_area: double.parse(data['living_area']),
      kitchen_area: double.parse(data['kitchen_area']),
      balcony_or_loggia: data['balcony_or_loggia'],
      bathrooms: int.parse(data['bathrooms']),
      toilet: int.parse(data['toilet']),
      heating: data['heating'],
      layout: data['layout'],
      window_view: data['window_view'],
      renovation: data['renovation'],
      elevators: int.parse(data['elevators']),
      new_building: data['new_building'] == 1 ? true : false,
      garages: data['garages'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'object_id': object_id,
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
      'garages': garages,
    };
  }
}

class ObjectPropertiesModel extends BaseModel {
  @override
  String table = 'object_properties';

  @override
  getById(int id) async {
    Map<String, dynamic>? data = await super.getById(id);

    if (data != null) {
      return ObjectProperties.fromMap(data);
    }
  }

  @override
  getAll() async {
    var data = await super.getAll();
    List<ObjectProperties> objectProperties = [];

    if (data != null) {
      for (var objectProperty in data) {
        objectProperties.add(ObjectProperties.fromMap(objectProperty.assoc()));
      }
    }

    return objectProperties;
  }
}