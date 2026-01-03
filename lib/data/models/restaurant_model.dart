import 'package:ahgzly_app/data/models/tabletype_model.dart';

class Restaurant {
  final int id;
  final String name;
  final String? address;
  final List<TableType> tableTypes;

  Restaurant({
    required this.id,
    required this.name,
    this.address,
    required this.tableTypes,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      tableTypes: (json['table_types'] as List)
          .map((i) => TableType.fromJson(i))
          .toList(),
    );
  }
}

