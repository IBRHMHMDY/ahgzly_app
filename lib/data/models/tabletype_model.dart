class TableType {
  final int id;
  final String name;
  final int capacity;
  final int quantity;

  TableType({required this.id, required this.name, required this.capacity, required this.quantity});

  factory TableType.fromJson(Map<String, dynamic> json) {
    return TableType(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      quantity: json['quantity'],
    );
  }
}
