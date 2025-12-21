class Resource {
  final int id;
  final String name;
  final String unit; // ex: SCU, kg, unités

  Resource({
    required this.id,
    required this.name,
    required this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id == 0 ? null : id,
      'name': name,
      'unit': unit,
    };
  }

  factory Resource.fromMap(Map<String, dynamic> map) {
    return Resource(
      id: map['id'] as int,
      name: map['name'] as String,
      unit: map['unit'] as String,
    );
  }
}
